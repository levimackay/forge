# FORGE: Architecture

Status: proposed, Phase 0. No implementation exists yet. This document states a direction and, more importantly, states which parts of that direction are expected to be wrong. Sections marked **Revisit** identify decisions that should be reopened deliberately rather than defended out of habit.

Formal decisions live in [decisions/](decisions/) as architecture decision records.

## Design goals

The architecture serves five properties, in priority order:

1. **The domain is testable without a UI.** Recommendation and progress are the interesting parts of FORGE. They must be exercisable in tests that construct a history, run the scoring function, and assert on the ranking, with no view, no database, and no clock dependency.
2. **History is durable and honest.** What the user actually did is a permanent fact. The system's interpretation of those facts is not, and must be replaceable without destroying them.
3. **The recommender is swappable.** The v1 heuristic and any future model must be interchangeable behind one boundary, so that a new implementation can be scored against the old one on real recorded history.
4. **Boundaries are small enough to hold in one head.** Every type answers three questions: what does it do, how is it used, what does it depend on.
5. **The platform is used, not abstracted away.** Adding a layer to insulate the app from SwiftUI or SwiftData buys portability nobody wants and costs clarity everyone needs.

## Platform baseline

**Swift 6 with strict concurrency.** Data race safety enforced at compile time. This is a real cost early and a real saving later, and for a project whose purpose includes demonstrating engineering judgment, opting out of the compiler's help is the wrong signal. Concurrency is handled with `async`/`await` and actors. No completion handlers, no Combine.

**iOS 26 minimum.** The install base is irrelevant for a personal app, and the newer floor removes an entire category of compatibility branching. It also makes the on-device Foundation Models framework available later without a deployment target migration, which matters for the Phase 4 intelligence work where the input data is personal.

**SwiftUI.** The whole app. Native feel, Dynamic Type, accessibility, and the modern system look come mostly for free, and they are expensive to reproduce otherwise.

**Observation.** `@Observable` model types observed directly by views. The `ObservableObject` and `@Published` generation is superseded, and Observation's fine-grained dependency tracking avoids the whole-object invalidation problem.

## Domain model

The model separates two categories of data, and this separation is the spine of the architecture.

**Facts** are what happened. A mission was completed at a time, took a duration, was rated a difficulty. Facts are append-only. Nothing in the system rewrites them.

**Derived state** is the system's interpretation. Skill proficiency, momentum, and mission ranking are all computed from facts. Derived state can be recomputed from scratch at any time, and improving the algorithm improves the past as well as the future.

The practical consequence: when the recommendation model changes in Phase 2 or Phase 4, no migration is required and no history is corrupted. The new model simply reads the same facts and reaches different conclusions. See [decisions/0002-facts-are-append-only.md](decisions/0002-facts-are-append-only.md).

Proposed entities:

| Entity | Kind | Purpose |
| --- | --- | --- |
| `Goal` | Fact | A long-horizon ambition. Title, motivation, horizon, primary flag, archived flag. |
| `Skill` | Fact | A named capability. Shared across goals. |
| `GoalSkill` | Fact | Join between a goal and a skill, carrying the weight of that dependency. |
| `Mission` | Fact | A bounded unit of work. Definition of done, time box, difficulty, primary skill, secondary skills, origin (proposed or user-written). |
| `MissionOutcome` | Fact | The record of a mission being completed, abandoned, or skipped. Timestamp, actual duration, self-rated difficulty, note. |
| `SkillEstimate` | Derived | Current proficiency, confidence, last practiced, decay. Computed from outcomes. |
| `Recommendation` | Derived | A ranked mission plus a human-readable justification. |

`Skill` deliberately has no stored proficiency field. Proficiency is a function of outcomes. Storing it invites two sources of truth that will eventually disagree.

**Revisit:** whether `SkillEstimate` should be cached in the store for performance once the outcome history is large, and if so, how invalidation is guaranteed. Start with pure computation and only cache when a measurement, not an intuition, says to.

## Persistence

**SwiftData**, with the caveats below. It is the native option, it is declarative, it integrates with SwiftUI querying, and it has a supported path to CloudKit sync in a later phase. For a single-user, modest-volume, local-first app, it is the right default. See [decisions/0001-swiftdata-persistence.md](decisions/0001-swiftdata-persistence.md).

The known risks, stated up front so they are not discovered as surprises:

- SwiftData's migration story is less battle-tested than Core Data's, and this project will change its schema repeatedly during Phase 1 and Phase 2.
- CloudKit sync through SwiftData imposes constraints on the model, notably around required attributes and unique constraints. Designing the model with those constraints in mind from the start is cheaper than retrofitting.
- Complex queries and aggregation are weaker than raw Core Data or SQL.

Mitigation: the domain logic does not import SwiftData. Scoring and progress computation operate on plain Swift value types. A thin repository layer converts between persisted models and those values. If SwiftData has to be replaced, the replacement is contained.

**Revisit:** if migration pain or query limitations become the dominant source of friction, evaluate Core Data or GRDB. The decision should be made on evidence from actual development, not from blog posts.

## Application structure

Proposed module boundaries, likely as Swift packages in a local package manifest so that the boundaries are enforced by the compiler rather than by good intentions.

```text
ForgeKit          Domain types, scoring, progress computation. No UI, no persistence, no I/O.
ForgeData         SwiftData models and repositories. Depends on ForgeKit.
ForgeUI           Design system primitives. Type scale, color, spacing, motion, components.
Forge             The app. Screens, navigation, composition root. Depends on all of the above.
```

`ForgeKit` is the package that matters. It should be pure, deterministic, and fully covered by tests. Every interesting claim FORGE makes is a claim about code in `ForgeKit`.

**Revisit:** four packages may be premature for an app this size. If the split creates more ceremony than clarity in the first weeks, collapse `ForgeUI` into the app target and keep only the `ForgeKit` boundary, which is the one that carries real weight.

## Presentation architecture

Views observe `@Observable` models directly. There is no view model layer by default.

MVVM in SwiftUI is frequently a habit imported from UIKit, where it solved a real problem. With Observation, a view model that only republishes model state is a layer of indirection that adds files and removes clarity. A view model is justified when a screen owns genuinely non-trivial ephemeral state: a multi-step form with validation and partial input, for example. Introduce one there and nowhere else. See [decisions/0004-views-observe-models-directly.md](decisions/0004-views-observe-models-directly.md).

**Revisit:** if screens start accumulating logic that is awkward to test through the view, that is the signal that the boundary is in the wrong place. The response is to push logic down into `ForgeKit`, and only then to consider a view model.

## The recommendation boundary

The most important interface in the system:

```text
MissionRecommending
  given: the user's goals, skills, outcome history, and the time available now
  returns: a ranked set of candidate missions, each with a justification
```

Everything about how a mission is chosen sits behind that boundary. Version 1 implements it as a deterministic scoring function combining skill weakness, time since last practice, parent goal weight, and fit to available time. It is readable, it is testable, and it can explain itself in a sentence.

Two properties are non-negotiable regardless of implementation:

1. **Determinism given inputs.** Same history, same available time, same ranking. This is what makes the recommender testable and what makes comparing two implementations meaningful. Time is injected, never read from `Date()` inside the scorer.
2. **Justification is part of the return value, not a separate explanation feature.** An implementation that cannot say why it chose something does not satisfy the protocol.

A future model-based implementation conforms to the same protocol and is evaluated by replaying recorded history through both and comparing acceptance rates. See [decisions/0003-recommendation-behind-a-protocol.md](decisions/0003-recommendation-behind-a-protocol.md).

## Dependency injection

Constructor injection, with protocol boundaries only where more than one implementation genuinely exists or is planned: the recommender, the clock, and the repository layer. The app's composition root wires the concrete graph at launch; SwiftUI's environment carries what the view tree needs.

No DI container or service locator. A registry that resolves dependencies at runtime trades compile-time safety for flexibility this project does not need.

**Revisit:** if constructor injection starts producing initializers with six parameters, that is a signal about the shape of the types, not a signal to add a container.

## Protocol-oriented design, used sparingly

Protocols where substitution is real: `MissionRecommending`, `Clock`, and the repositories. Concrete types everywhere else.

The failure mode worth naming: a protocol for every type, each with exactly one conformance, written for a testability that plain values already provide. `ForgeKit` operates on value types with no I/O, which means most of it needs no mocking at all. A protocol with one implementation and no plausible second one is indirection charged to every future reader.

## Testing

**Swift Testing** as the framework. Tests are structured in three tiers, with effort concentrated at the bottom.

**Domain tests** cover `ForgeKit` and carry the weight. Construct a synthetic history, run the scorer, assert on the ranking and the justification. Property-style tests for the invariants that must always hold: a skill practiced today never ranks above an equally weighted skill untouched for a month, available time is never exceeded, and recomputing derived state from the same facts always gives the same answer.

**Repository tests** verify that persistence round-trips correctly and that migrations do not lose facts, run against an in-memory store.

**UI tests** are few and cover only the critical path: create a goal, add skills, receive a mission, complete it, see progress change. UI tests are slow and brittle, so they earn their place by covering the loop that defines the product, not by chasing coverage.

The rule: any bug in scoring or progress gets a failing domain test before it gets a fix.

## Performance

The app must be fast enough to use in the ten seconds between deciding to work and starting. That is a product requirement, so it is an architectural one.

Targets to hold as the codebase grows: cold launch to a visible recommendation under one second on current hardware, no main-thread work for scoring once history is non-trivial, and no synchronous store fetches during view body evaluation.

Scoring is pure and cheap enough to run synchronously at first. Move it off the main actor when a measurement says to, not before.

## Open questions

Genuinely undecided, recorded here so they are not accidentally settled by whatever is written first:

- How proficiency decays over time, and whether decay rate should differ per skill.
- Whether a skill's proficiency estimate should carry an explicit confidence, and how that confidence is presented without becoming clutter.
- How competing goals are balanced when their skills conflict for the same limited time.
- Whether missions should be generated on demand or maintained as a standing backlog per skill.
- How a user corrects the system when its picture of them is wrong, without letting them edit history.
- Whether the four-package split survives contact with the first month of real work.
