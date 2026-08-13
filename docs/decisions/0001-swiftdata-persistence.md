# 0001: SwiftData as the persistence layer

Status: accepted
Date: 2026-08-13

## Context

FORGE stores goals, skills, missions, and an outcome history that grows by a handful of records per day. The data is single-user, local-first, and modest in volume. It must eventually sync across a user's own devices, and it must survive frequent schema changes during Phase 1 and Phase 2, when the domain model is still being discovered.

The persistence choice is load-bearing in two ways. It determines how painful schema evolution is during the phase when the schema changes most, and it determines how hard CloudKit sync is in Phase 3.

## Decision

Use SwiftData, with the domain layer kept free of it.

`ForgeKit` operates on plain Swift value types and imports no persistence framework. `ForgeData` owns the SwiftData models and exposes repositories that convert between stored models and domain values. Nothing above `ForgeData` knows what the storage engine is.

## Alternatives considered

**Core Data.** More mature, better documented failure modes, a migration story with fifteen years of accumulated knowledge, and stronger querying. It loses on ergonomics: the model editor, the boilerplate, and the impedance mismatch with SwiftUI and Swift concurrency add friction to every single change. For a project of this size and volume, that friction outweighs the maturity advantage.

**GRDB or raw SQLite.** Excellent control, predictable performance, migrations that are just ordered SQL, and no framework surprises. It loses on integration: SwiftUI querying, CloudKit sync, and the observation story all become the project's problem to solve rather than the platform's. Choosing it also means writing more infrastructure and less product.

**Codable files on disk.** Trivially simple and adequate at current volume. It loses because sync, querying, and concurrent access all eventually need to be built by hand, and the crossover point where that becomes painful arrives sooner than it looks.

## Consequences

**Easier.** Model definitions are Swift types with macros rather than an editor and generated classes. SwiftUI querying and Observation integrate without adapters. CloudKit sync in Phase 3 has a supported path instead of a bespoke one. Less infrastructure code means more attention on the recommender, which is where the actual value is.

**Harder.** SwiftData's migration tooling is younger than Core Data's, and this project will exercise it heavily during the phase when the schema is least stable. Complex aggregation queries are weaker. Debugging is harder when the framework misbehaves, because the community knowledge base is thinner.

**Committed to.** iOS 26 as a floor, which was already the platform decision. Designing the model within CloudKit's constraints from the start, notably around optionality and unique constraints, because retrofitting those is worse than accepting them early.

The insulation is the hedge. Because domain logic never touches SwiftData, replacing it means rewriting `ForgeData`, not rewriting FORGE.

## Revisit when

- A schema migration loses data or requires a destructive reset in normal development
- CloudKit sync in Phase 3 requires model contortions that make the domain harder to reason about
- A progress or scoring query needs aggregation that SwiftData cannot express cleanly

Any of those is grounds to evaluate GRDB behind the same repository interface.
