# Architecture Decision Records

Short documents recording choices that were expensive to make and would be expensive to reverse.

A decision gets a record when one of these is true:

- Reversing it later would require touching a lot of code
- A reasonable engineer would plausibly have chosen differently
- A future reader would otherwise look at the code and wonder why it is like this

Small, obvious, or easily reversible choices do not need one. A directory full of records for decisions nobody would question is noise that hides the three that matter.

## Format

```markdown
# NNNN: Title

Status: proposed | accepted | superseded by NNNN
Date: YYYY-MM-DD

## Context
What situation forced a decision. What constraints applied.

## Decision
What was chosen, stated plainly.

## Alternatives considered
What else was on the table and why it lost. This section is the reason the
document is worth writing.

## Consequences
What this makes easy, what it makes hard, and what it commits the project to.

## Revisit when
The concrete signal that should reopen this decision.
```

Superseded records are marked superseded and kept. The reasoning behind a decision that turned out to be wrong is usually the most useful thing in the directory.

## Records

| # | Title | Status |
| --- | --- | --- |
| [0001](0001-swiftdata-persistence.md) | SwiftData as the persistence layer | Accepted |
| [0002](0002-facts-are-append-only.md) | Facts are append-only, interpretation is derived | Accepted |
| [0003](0003-recommendation-behind-a-protocol.md) | Recommendation sits behind a protocol, v1 is deterministic | Accepted |
| [0004](0004-views-observe-models-directly.md) | Views observe models directly, no view model layer by default | Accepted |
