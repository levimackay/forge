# 0002: Facts are append-only, interpretation is derived

Status: accepted
Date: 2026-08-13

## Context

FORGE's central promise is that its recommendations improve over time. That means the algorithm producing them will change repeatedly: a deterministic heuristic in Phase 1, a tuned model in Phase 2, possibly a learned one in Phase 4.

Every one of those changes reinterprets the user's history. If the system stores its interpretation as if it were a fact, then improving the algorithm either corrupts the record or requires a data migration that guesses at what the old numbers meant. Both outcomes are bad, and the second one gets worse the longer the app has been in use.

There is also an honesty problem. FORGE tells users things about themselves. It should be able to show its work, and it cannot do that if the underlying evidence has been overwritten by conclusions drawn from it.

## Decision

Split the data model into two categories with different rules.

**Facts** are records of what happened: a mission was completed at a time, took a duration, was rated at a difficulty, or was skipped. Facts are written once and never modified by the system. The user can add a fact and can annotate one, but nothing in FORGE rewrites history to match a new belief about it.

**Derived state** is the system's current interpretation: skill proficiency, momentum, decay, and mission ranking. Derived state is computed from facts on demand and holds no independent authority. It can be thrown away and recomputed at any time without loss.

Concretely, `Skill` has no stored proficiency field. Proficiency is a function over that skill's outcome history.

## Alternatives considered

**Store a running proficiency and update it on each completion.** Simpler and faster to read. It loses because it creates two sources of truth that will eventually disagree, and because changing the update rule leaves every historical value stale and unfixable. It also makes the "show me why you think that" feature impossible to build honestly.

**Store both, with derived values cached and invalidated on write.** A reasonable optimization, and probably where this ends up. It loses as a starting point because cache invalidation is a bug source, and the volume here is a few hundred records per year, which does not justify the risk yet.

**Event sourcing with a formal event log and projections.** The same idea taken further, and philosophically a good match. It loses on weight: a full event store, replay machinery, and projection versioning is a large amount of infrastructure for a single-user app, and it would consume the attention that belongs on the recommender.

## Consequences

**Easier.** Changing the recommendation algorithm requires no migration and destroys no history. Two algorithms can be run against identical history and compared, which is what makes the Phase 2 evaluation harness possible at all. The app can always show the evidence behind any claim it makes. Undo and correction are simpler when nothing is destructive.

**Harder.** Reads cost computation instead of a lookup. Derived state has to be recomputed or cached carefully once it appears in more than one place. It requires discipline: the tempting shortcut of writing a number back onto a `Skill` will present itself repeatedly, and taking it once quietly breaks the property.

**Committed to.** Time is an explicit input to derivation rather than something read from `Date()` inside a computation, because otherwise derived values are not reproducible and cannot be tested.

## Revisit when

Profiling shows derivation is a real cost at realistic history sizes. The response is to cache derived values with explicit invalidation, not to make facts mutable. The append-only property is the part that must survive.
