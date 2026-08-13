# Contributing to FORGE

FORGE is currently developed by one person. These standards exist anyway, because the point of writing them down is to hold the work to a consistent bar when nobody is watching, and because a project that may become public should already behave like one.

If you are considering contributing: open an issue describing the problem before writing code. FORGE has a narrow, opinionated scope, and a well-built feature that does not belong in the product still gets declined. That conversation is cheaper before the work than after it.

## Requirements

- Xcode 26 or later
- iOS 26 SDK
- Swift 6 with strict concurrency enabled

There is no additional setup. The project builds and its tests run with no network access, no API keys, and no local services.

## Development expectations

**Read the docs first.** [docs/PRODUCT.md](docs/PRODUCT.md) defines scope, [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) defines structure, and [docs/DESIGN.md](docs/DESIGN.md) is binding on anything the user sees. A change that contradicts one of those documents is not automatically wrong, but it requires editing that document first, in its own commit, with the reason stated.

**One concern per change.** A branch that fixes a bug, renames three types, and adjusts spacing is three changes wearing one coat, and it is much harder to review or revert than three branches would have been.

**Domain logic belongs in `ForgeKit`.** If it can be decided without a view and without a database, it goes in the domain layer where it can be tested directly. Logic that ends up in a view body is logic that is hard to test and easy to break.

**No new dependency without a decision record.** Every dependency is a permanent maintenance obligation, a build time cost, and a future migration. The bar is high and the burden of proof is on adding it.

**Leave the uncertainty visible.** Where a decision is a guess, say so in the code or in the architecture document. Unmarked guesses become load-bearing assumptions that nobody remembers questioning.

## Code quality

- Follow the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/). Clarity at the point of use beats brevity at the point of definition.
- Strict concurrency stays on. Do not silence a data race warning with `@unchecked Sendable` or an unstructured `Task` unless the reason is documented in a comment at that line.
- Prefer value types. Reach for a reference type when identity or shared mutable state is genuinely required.
- Prefer concrete types. A protocol with one conformance and no plausible second one is indirection charged to every future reader.
- Name things for what they mean in the domain, not for their implementation. `MissionOutcome` beats `MissionRecord`, and both beat `MissionData`.
- Comments explain why. The code already explains what, and a comment that restates it will eventually contradict it.
- Delete dead code rather than commenting it out. Git remembers.
- Formatting is not a matter of taste. Match the surrounding file.

## Testing

Tests use [Swift Testing](https://developer.apple.com/documentation/testing). The expectations scale with what the code does:

**Domain code requires tests.** Scoring, ranking, and progress derivation are the substance of FORGE, and they change behavior invisibly when they break. Every scoring or progress change ships with tests that would fail without it.

**Bugs get a failing test first.** Reproduce the defect in a test, watch it fail, then fix it. A fix without a test is an invitation for the same bug to return.

**Invariants get asserted, not assumed.** Time is injected rather than read from `Date()`, so ranking is reproducible. A skill practiced today never outranks an equally weighted skill untouched for a month. A recommendation never exceeds the stated available time. Recomputing derived state from unchanged facts always produces the same answer.

**UI tests stay few and stay on the critical path.** Create a goal, add skills, receive a mission, complete it, see progress change. UI tests are slow and brittle, and their value is confirming the loop works, not raising a coverage number.

**Coverage is not the target.** A high number achieved by testing getters is worse than a lower number concentrated on the recommender, because it produces false confidence.

The full test suite must pass before a pull request is opened. "It passes locally except for one flaky test" means there is a bug in the test.

## Commits

[Conventional Commits](https://www.conventionalcommits.org/), imperative mood, present tense.

```text
<type>(<scope>): <subject>

<body: why this change, not what it does>
```

Types: `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `build`, `chore`.

Scopes follow the packages and domains: `kit`, `data`, `ui`, `app`, `docs`, `design`.

```text
feat(kit): weight skill recency by parent goal priority
fix(data): preserve outcome timestamps across schema migration
docs(architecture): record why the recommender sits behind a protocol
```

Subject lines stay under 72 characters and do not end with a period. The body explains reasoning, and it is optional only when the subject is genuinely complete on its own.

Commits are self-contained. Each one should build and pass tests, because a commit that does not is a commit you cannot bisect through.

## Pull requests

Small enough to review carefully. If a diff cannot be read in one sitting, it should have been more than one pull request.

Every pull request states:

- **What changed and why.** The why is the part reviewers cannot reconstruct from the diff.
- **How it was verified.** Which tests were added, and what was checked manually.
- **What it does not do.** Known gaps and deliberate omissions, so a reviewer does not report them as findings.
- **Screenshots or a screen recording** for any user-visible change, in both light and dark appearance. If the change affects layout, include the largest Dynamic Type size.

Before opening one:

- The full test suite passes
- The build is free of new warnings
- Documentation affected by the change is updated in the same pull request
- Any user-visible change has been checked against the review questions in [docs/DESIGN.md](docs/DESIGN.md)
- Any architectural decision has a decision record in [docs/decisions/](docs/decisions/)

Review is about the code. Direct feedback on a change is not feedback on the person who wrote it, and rigor is the point.

## Documentation

Documentation is part of the change, not a follow-up task. A pull request that alters behavior described in `docs/` and does not update `docs/` is incomplete.

**Decision records** live in [docs/decisions/](docs/decisions/), numbered sequentially, following the existing format. Write one when a choice will be expensive to reverse, when a reasonable engineer would choose differently, or when a future reader would otherwise wonder why the code looks like this. Superseded records are marked superseded, not deleted, because the reasoning that turned out to be wrong is often the most useful thing in the file.

**Code documentation** uses DocC comments on public API in `ForgeKit`, explaining what a type is for in domain terms. Internal implementation details do not need doc comments, and adding them to satisfy a linter produces noise.

**Prose standards.** Write plainly. No marketing language, no filler, and no claims the code does not support.
