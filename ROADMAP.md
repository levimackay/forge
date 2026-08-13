# FORGE: Roadmap

No dates. A phase is finished when its exit criteria are met, and not because a week ended.

The ordering optimizes for two things: learning whether the core idea is actually useful as early as possible, and building the boring foundation well enough that the interesting work later is not fighting it. Speed is explicitly not a goal. A rushed core loop produces a product that is hard to trust and a codebase that is hard to extend, and both of those cost more than the time they save.

Phases 2 and beyond are provisional. Daily use of Phase 1 will change them, and it should.

---

## Phase 0: Foundation

Establish what FORGE is before writing code that assumes an answer.

- Product definition: user, problem, core loop, MVP scope, non-goals, success criteria
- Architecture direction, with the uncertain decisions labeled as uncertain
- Design language: the one visual idea, type, color, motion, accessibility floor
- Roadmap and contribution standards
- Repository, issue templates, decision record format

**Exit criteria:** a reader who has never heard of FORGE can explain what it does, what version 1 will contain, and what it deliberately will not contain.

**Status: complete.**

---

## Phase 1: Core loop

The smallest thing that closes the loop. One device, no network, no intelligence.

- Xcode project, package structure, strict concurrency enabled from the first commit
- Domain model in `ForgeKit`: goals, skills, weighted goal-skill relationships, missions, outcomes
- Persistence in `ForgeData` with repositories over SwiftData
- Deterministic scoring function with justification, behind `MissionRecommending`
- Progress computation derived from the outcome record
- Design system primitives: type scale, palette, spacing, the heat accent rule
- Navigation and the primary screen
- Goal creation, skill creation and weighting
- The mission flow: receive one recommendation, accept, skip, or replace, then record the outcome
- Skill progress view showing evidence rather than a score
- Domain test suite covering scoring, ranking invariants, and progress derivation
- Accessibility pass: Dynamic Type through AX5, VoiceOver, Reduce Motion

**Exit criteria:** the loop runs end to end on a device, the recommendation can explain itself in a sentence, and the author has used it for two full weeks without touching the code to make it work.

---

## Phase 2: Personalization

Make the recommendations actually fit the person, using the evidence Phase 1 collected.

- Skill proficiency decay, tuned against real recorded history
- Skip and abandonment signals feeding back into ranking
- Estimation error tracking: the gap between stated and actual mission duration
- Balancing skills across competing goals rather than serving only the primary one
- A way for the user to correct the system's picture of them without editing history
- Evaluation harness that replays recorded history through two recommenders and compares them
- Onboarding for the first goal, which is the point most users would otherwise quit

**Exit criteria:** the new recommender beats the Phase 1 heuristic on recorded acceptance rate, measured through the evaluation harness rather than asserted.

---

## Phase 3: Apple platform integration

Extend the loop to where the decision actually happens, which is usually not inside the app.

- Home screen and lock screen widgets showing the current mission
- App Intents so a mission can be started and completed from Siri, Shortcuts, and Spotlight
- Live Activity for a mission in progress
- Notifications, if and only if a real need for them emerges from use. Silence is the default
- CloudKit sync, with conflict resolution that never loses a recorded fact
- Apple Watch companion for starting and completing missions

**Exit criteria:** a mission can be started and finished without opening the app, and sync has run across two devices for two weeks without a lost or duplicated outcome.

---

## Phase 4: Intelligence

Only now, and only where it beats the deterministic baseline.

- Goal decomposition: turning a stated ambition into a first draft skill tree
- Mission generation grounded in the user's actual history rather than generic templates
- On-device inference through Foundation Models where the input is personal
- Personal knowledge graph connecting goals, skills, missions, and completed work
- Guardrails: every generated mission is editable, attributable, and rejectable, and the app remains fully functional when generation is unavailable

**Exit criteria:** an intelligent recommender wins against the Phase 2 recommender on the evaluation harness, and the app still works completely with all generation disabled.

---

## Phase 5: Production

Turn a working app into a shippable one.

- Performance: cold launch to visible recommendation under one second, scoring off the main actor, memory and instrument passes
- Test coverage where it matters, plus the critical-path UI tests
- Full accessibility audit against the DESIGN.md floor, on device with VoiceOver
- Privacy: data stays on device or in the user's own iCloud, with an honest privacy policy
- Export, so the user's record is theirs and is not hostage to the app
- Localization readiness
- App Store materials: screenshots, description, and a listing that does not oversell
- Analytics, if any, privacy-preserving and used to improve recommendations rather than to measure engagement

**Exit criteria:** submitted, and usable by someone who is not its author without a conversation first.

---

## Deliberately not on this roadmap

Team features, social accountability, a mission marketplace, subscription mechanics, gamification systems, a web version, and an Android version. Each of these would change what FORGE is. If one of them ever belongs here, it belongs here after the core product has proven it works, and it arrives through a decision record explaining what changed.
