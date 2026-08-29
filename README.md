# FORGE

![Platform](https://img.shields.io/badge/platform-iOS%2026%2B-1c1c1e?style=flat-square)
![Language](https://img.shields.io/badge/swift-6-1c1c1e?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-1c1c1e?style=flat-square)
![Status](https://img.shields.io/badge/status-phase%201%20%C2%B7%20core%20loop-8a5a2b?style=flat-square)

A native iOS app that's Duolingo for CS fundamentals, built for students prepping for technical interviews.

I built FORGE because "get ready for interviews" doesn't tell you what to open on a Tuesday night with forty free minutes. FORGE breaks CS fundamentals like data structures and algorithms into a skill tree, hands you one concrete mission at a time, and uses what you actually complete to decide what to recommend next, so weak topics don't stay invisible until they show up in an interview.

```text
Goal -> Skills -> Progress -> Recommended Mission -> Completion -> Updated Progress
```

It's not a habit tracker and not a todo list. A habit tracker records that you did something. FORGE decides what's worth doing next based on evidence, and shows its reasoning in plain language instead of hiding it behind a model you can't inspect.

## Status

Phase 1: core loop. Phase 0 (product spec, architecture, design language, roadmap) is done. The Xcode project and the `ForgeKit` / `ForgeData` / `ForgeUI` package split are in place with strict concurrency on from the first commit. Next: the domain model, SwiftData persistence, and a deterministic scoring function for the recommender.

## How it works

**Goal** is the long term ambition. It's never scheduled or checked off.

**Skill** is a specific capability a goal depends on, weighted per goal.

**Mission** is one bounded task that develops a skill, with a stated time and an unambiguous definition of done.

**Progress** is the record of missions actually completed, which feeds straight back into the next recommendation.

The v1 recommender is deterministic, not AI. It ranks missions on skill weakness, time since last practiced, how much the goal weights that skill, and how much time you have. Explainable and testable beats a black box, and it's the baseline any future model has to beat.

## Stack

SwiftUI, Swift 6 with strict concurrency, SwiftData for persistence, split into `ForgeKit` (domain model), `ForgeData` (persistence), and `ForgeUI` (design system).

## Docs

| Document | Contents |
| --- | --- |
| [docs/PRODUCT.md](docs/PRODUCT.md) | Problem, core loop, MVP scope, non-goals |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Technical architecture and open decisions |
| [docs/DESIGN.md](docs/DESIGN.md) | Design philosophy, visual language, motion, accessibility |
| [ROADMAP.md](ROADMAP.md) | Phased plan from foundation to production |
| [docs/decisions/](docs/decisions/) | Architecture decision records |

## Author

Levi Mackay

## License

MIT. See [LICENSE](LICENSE).
