## What changed

<!-- One or two sentences. -->

## Why

<!-- The reasoning a reviewer cannot reconstruct from the diff. Link the issue if there is one. -->

Closes #

## How it was verified

<!-- Tests added, and what was checked by hand. -->

## What this does not do

<!-- Known gaps and deliberate omissions, so a reviewer does not report them as findings. -->

## Screenshots

<!-- Required for any user-visible change: light and dark appearance. Include the largest Dynamic Type size if layout is affected. Delete this section if nothing visible changed. -->

## Checklist

- [ ] One concern. This is not several changes in one branch
- [ ] Full test suite passes
- [ ] Build produces no new warnings, and strict concurrency is not silenced
- [ ] Domain logic lives in `ForgeKit`, not in a view
- [ ] Behavior changes in scoring or progress are covered by tests that would fail without this change
- [ ] Affected documentation updated in this pull request
- [ ] User-visible changes checked against the review questions in `docs/DESIGN.md`
- [ ] Accessibility verified: Dynamic Type, VoiceOver, Reduce Motion
- [ ] Architectural decisions recorded in `docs/decisions/`
- [ ] No new dependency, or a decision record justifies it
