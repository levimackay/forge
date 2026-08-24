# FORGE

![Platform](https://img.shields.io/badge/platform-iOS%2026%2B-1c1c1e?style=flat-square)
![Language](https://img.shields.io/badge/swift-6-1c1c1e?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-1c1c1e?style=flat-square)
![Status](https://img.shields.io/badge/status-phase%200%20%C2%B7%20foundation-8a5a2b?style=flat-square)

A native iOS personal development system that turns long-term goals into adaptive daily missions.

FORGE exists to answer one question, well, every day:

> **What should I do right now to become better?**

Most people who want to improve at something difficult do not fail because they lack ambition. They fail because ambition does not tell them what to open on a Tuesday night when they have forty free minutes. FORGE closes that gap. You describe where you want to end up, FORGE breaks it into the skills that goal actually depends on, and then it hands you one concrete thing to do right now.

```text
Goal
  ↓
Skills
  ↓
Progress
  ↓
Recommended Mission
  ↓
Completion
  ↓
Updated Progress
  ↓
Better Recommendations
```

Every completed mission feeds back into the model of what you are good at, which changes what FORGE asks of you next. The loop tightens over months, not minutes.

FORGE is not a habit tracker and it is not a todo list. A habit tracker records that you did something. A todo list records that you intended to. FORGE is meant to decide, on evidence, what is worth doing next, and to be honest with you about whether it is working. The long-term goal is an intelligent personal development system. The first version is a deliberately small piece of that.

## Status

Phase 0. This repository currently holds the product definition, architecture direction, design language, and roadmap. There is no application code yet, and that is intentional. The domain model and the shape of the recommendation system are the hard parts of this project, so they get written down before anything is built.

## The problem

People with ambitious goals routinely do not know:

- What they should work on today
- Which skill they are actually weak at, as opposed to which one feels uncomfortable
- Whether the work they are doing moves them toward the goal or just feels productive
- What to prioritize when they have thirty minutes instead of three hours
- How to keep momentum across months and years rather than across a good week

The common failure is not laziness. It is that a goal like "become a strong software engineer" is not actionable, and the translation from that sentence into "spend the next hour on two graph traversal problems" is real cognitive work that nobody wants to do at the moment they finally have time to work.

FORGE does that translation.

## Core concept

Four ideas, in a chain:

**Goal → Skills → Missions → Progress**

A **Goal** is a long-horizon ambition. It is not scheduled and it does not get checked off.

A **Skill** is a specific capability that a goal depends on. Goals weight their skills, because not every skill matters equally to every goal.

A **Mission** is one bounded, concrete piece of work that develops one or more skills. It fits in a stated amount of time and it has an unambiguous definition of done.

**Progress** is the record of missions you actually completed, and the picture of proficiency derived from that record.

```text
Goal:
Become a strong software engineer

Skills:
Algorithms
Swift
System Design
Networking
Data Structures

Mission:
Complete two graph traversal problems

Result:
Graph Algorithms mastery increases
Progress is recorded
Future missions adapt
```

The important detail is the direction of that last arrow. Progress is not a display feature bolted onto a task app. Progress is the input to the next recommendation. If the record says you have not touched system design in three weeks and your primary goal weights it heavily, that is what FORGE asks you to do next, and it tells you that is why.

## Product philosophy

**Native first.** FORGE should feel like an Apple application, not a website wearing an iPhone. That means real navigation, real gestures, real system integration, text that respects Dynamic Type, and behavior that matches what the platform already taught the user to expect.

**Calm over clutter.** One decision per screen. The app should be usable in the thirty seconds between deciding to work and starting to work. If a screen presents six choices, it has failed.

**Action over information.** A dashboard tells you how you are doing. FORGE tells you what to do. Analytics exist to serve the recommendation, not to entertain. Any chart that does not change a decision does not ship.

**Progress should be visible, and it should be evidence.** Users should be able to see that they are improving, and the proof should be the record of what they actually did, not a points total. FORGE does not award experience points, levels, badges, or confetti. It shows you the work.

**Intelligence should be useful.** AI earns its place only where it makes the product better at its one job: choosing what you should do next, and turning a vague ambition into a concrete mission. A chat window bolted to the side of a productivity app is not intelligence, it is a feature checkbox.

**Long-term thinking.** The unit of success is the month and the year, not the day. FORGE should never manufacture urgency, punish a missed day, or optimize for the streak at the expense of the goal. A system you can sustain for two years beats a system that is thrilling for nine days.

## Version 1

The first version implements one loop and nothing else:

```text
Create Goal
    ↓
Define Skills
    ↓
Receive Mission
    ↓
Complete Mission
    ↓
Record Result
    ↓
Update Progress
```

Concretely, v1 lets you create a goal, attach weighted skills to it, receive a single recommended mission, accept or skip it, record what actually happened when you finished, and see your skill picture change as a result.

The v1 recommender is a deterministic, explainable scoring function. It is not AI. It ranks candidate missions on skill weakness, how long it has been since a skill was practiced, how much the parent goal depends on that skill, and how much time the user says they have. It always shows its reasoning in plain language. This is a deliberate choice: a recommender you can read, test, and argue with is a better foundation than a model you cannot inspect, and it becomes the baseline that any future model has to beat.

Everything else is deferred. See [docs/PRODUCT.md](docs/PRODUCT.md) for the explicit list of things v1 will not do.

Development is incremental. Each phase in the roadmap produces something usable on its own.

## Future direction

The following are possibilities under consideration, not commitments. Nothing here is promised, and some of it will turn out to be a bad idea once the core loop is real and in daily use.

**Apple platform**

SwiftUI, SwiftData, CloudKit sync, WidgetKit home and lock screen widgets, App Intents and Siri, Live Activities for an in-progress mission, notifications, haptics, deep accessibility support, Apple Watch.

**Intelligence**

Adaptive mission recommendation that learns from acceptance and completion patterns, better skill modeling than a single proficiency number, personalized prioritization across competing goals, AI-assisted decomposition of a goal into skills, a personal knowledge graph connecting goals, skills, and completed work, and on-device inference through Foundation Models where the data is personal enough to justify it.

**Analytics**

Skill progression over time, momentum, consistency, time invested per goal, and honest goal progress estimates.

Which of these gets built depends entirely on what daily use of the core loop reveals.

## Documentation

| Document | Contents |
| --- | --- |
| [docs/PRODUCT.md](docs/PRODUCT.md) | User, problem, core loop, MVP scope, non-goals, success criteria |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Proposed technical architecture and the decisions to revisit |
| [docs/DESIGN.md](docs/DESIGN.md) | Design philosophy, visual language, motion, accessibility |
| [ROADMAP.md](ROADMAP.md) | Phased plan from foundation through production |
| [docs/decisions/](docs/decisions/) | Architecture decision records |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Development, testing, commit, and review expectations |

## Author

Levi Mackay

## License

MIT. See [LICENSE](LICENSE).

**Last updated:** 2026-08-23 21:37 PDT

