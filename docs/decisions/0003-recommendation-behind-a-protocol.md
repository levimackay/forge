# 0003: Recommendation sits behind a protocol, and v1 is deterministic

Status: accepted
Date: 2026-08-13

## Context

Choosing what the user should do next is the product. Everything else in FORGE is a way of collecting the inputs for that choice or presenting its result.

There is an obvious temptation to reach for a language model immediately. It would be faster to a demo and it would sound more impressive. It is also the decision that would make the project impossible to evaluate, because there would be no baseline to compare against, no way to tell whether the model helped, and no way to explain a recommendation to a user who disagrees with it.

## Decision

Define one protocol, roughly:

```text
MissionRecommending
  given: goals, skills and their weights, outcome history, and time available now
  returns: ranked candidate missions, each with a human-readable justification
```

Version 1 implements it as a deterministic scoring function over four inputs: how weak a skill is relative to its parent goal's weight, how long since that skill was practiced, how much the goal depends on it, and how well a candidate mission fits the stated available time.

Two properties hold for every implementation, present and future:

1. **Determinism given inputs.** The same history, available time, and reference date always produce the same ranking. Time is injected, never read from `Date()` inside the scorer.
2. **Justification is part of the return value.** An implementation that cannot say why it chose something does not satisfy the protocol. Explanation is not a separate feature layered on top.

## Alternatives considered

**Start with a language model.** Faster to something that looks intelligent, and better at handling goals the heuristic has no rules for. It loses on every property that matters here: it is non-deterministic, so it cannot be tested by asserting on a ranking; it has no baseline to be measured against; its explanations are generated rather than derived, which means they can be plausible and wrong; and it makes the core loop depend on availability and latency. It is the right tool later, evaluated against something.

**Hardcode the scoring into the view layer.** Fewer files, and honest about the size of the code. It loses because the scoring function is the one part of FORGE that must be tested exhaustively, and logic reachable only through a view is logic tested slowly and badly. It also forecloses the comparison harness entirely.

**Configurable rules engine with user-tunable weights.** Flexible, and it defers the hard modeling questions to the user. It loses because it makes the user do the work FORGE exists to do. If the app has to be configured to give good advice, it does not understand the user, and the configuration screen becomes the product.

## Consequences

**Easier.** The recommender is testable in isolation with synthetic histories and no I/O. Two implementations can be replayed against the same recorded history and compared on acceptance rate, which is the only honest way to claim an improvement. Every recommendation can explain itself, which builds trust and makes disagreement diagnostic rather than frustrating. The app works offline, always, with no model dependency.

**Harder.** The heuristic will be wrong in ways a model would handle gracefully, particularly for goals whose skill structure does not fit its assumptions. Its weights need tuning against real use, and that tuning is manual in Phase 2. It cannot invent a mission it was never given.

**Committed to.** An evaluation harness in Phase 2 that replays history through two recommenders, because without it, the claim "the new one is better" is just an opinion. Any Phase 4 model has to beat the heuristic on that harness before it ships.

## Revisit when

The heuristic's skip rate stays above 40 percent after tuning against real recorded history. That is the signal that the model of the user is structurally wrong rather than merely mis-weighted, and it is the point where a learned approach earns its complexity.
