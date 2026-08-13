# 0004: Views observe models directly, no view model layer by default

Status: accepted
Date: 2026-08-13

## Context

SwiftUI projects routinely adopt MVVM, usually without stating what problem it is solving. The pattern arrived from UIKit, where view controllers accumulated logic and needed somewhere to put it, and it was reinforced in early SwiftUI by `ObservableObject`, whose coarse invalidation made a per-screen wrapper object feel natural.

The Observation framework changed that situation. `@Observable` types are tracked at the property level, so a view re-evaluates only when a property it actually read changes. A view model whose entire job is to republish model state now adds a file, an indirection, and a synchronization surface, in exchange for nothing.

FORGE also puts almost all of its interesting logic in `ForgeKit`, where it is tested directly with no view involved. The logic a view model would traditionally hold mostly does not exist here.

## Decision

Views observe `@Observable` model types directly. No view model layer by default.

A view model is introduced only where a screen owns genuinely non-trivial ephemeral state that does not belong in the domain: a multi-step form with partial input and validation is the clear case. It is introduced for that screen, and it is not adopted project-wide because one screen needed it.

## Alternatives considered

**MVVM everywhere.** Consistent, familiar to reviewers, and a comfortable answer to "what is the architecture". It loses because uniformity is not the same as correctness. Most FORGE screens read domain state and present it, and wrapping that in a per-screen object doubles the file count while making the data flow harder to follow, not easier.

**Redux or TCA-style unidirectional state.** Genuinely excellent for large applications with complex shared state, deep undo requirements, or many engineers who need enforced conventions. It loses here on proportion: FORGE is one person building a small app whose state is mostly persisted domain data. The ceremony would exceed the complexity it manages.

**Logic in view bodies, no structure at all.** Fastest at first. It loses immediately, because scoring and progress derivation must be testable without a UI, and this approach makes that impossible.

## Consequences

**Easier.** Fewer files and a data flow a reader can follow from the store to the pixel without an intermediate hop. Property-level invalidation without a manual republishing layer. The pressure to test through a view drops, because the logic worth testing is already in the domain package.

**Harder.** It requires judgment rather than a rule, which means it can drift. Reviewers accustomed to MVVM will read the absence of view models as an absence of architecture, so the reasoning has to be pointed at rather than argued fresh each time. Screens with real ephemeral state need someone to notice and to introduce a view model deliberately.

**Committed to.** Keeping domain logic in `ForgeKit`. This decision only holds if the domain layer stays the place where behavior lives. The moment scoring or progress logic migrates into views, the absence of a view model layer becomes a real problem rather than a simplification.

## Revisit when

A screen's logic becomes awkward to test through the view. The first response is to move that logic down into `ForgeKit`, because that is usually where it belonged. Only if it is genuinely presentation-specific does it earn a view model.
