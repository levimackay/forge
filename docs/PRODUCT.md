# FORGE: Product Specification

Status: draft, Phase 0. This document defines what FORGE is for and what the first version must do. It will be revised as daily use of the core loop reveals what is actually true.

## User

Computer science students preparing for technical interviews: mastering data structures and algorithms, and the rest of the fundamentals a whiteboard or online assessment expects, with limited and irregular free time. That person already knows roughly what "ready" looks like. What they lack is a reliable way to convert that into the right forty minutes of practice tonight, and a system that keeps score of which topics are actually solid versus which ones they are avoiding.

Building for one real user with a real problem is deliberate. FORGE is designed to be used every day by its author, a CS student in the middle of his own interview prep, before it is designed to be used by anyone else. A product that survives that test has a chance of being useful to the wider population of students in the same position. A product that does not survive it should not ship.

Who FORGE is not for, at least initially: teams, coaches managing other people, anyone looking for a general task manager, and anyone past the fundamentals stage looking for company-specific mock interviews. FORGE is a Duolingo for CS fundamentals, not a LeetCode clone or a mock-interview platform.

## Problem

Ambition is abstract. Action is concrete. The gap between them is where most self-directed improvement dies.

The specific failures FORGE targets:

1. **The translation problem.** "Get ready for technical interviews" does not tell you what to open. Doing that translation costs energy at exactly the moment you have the least of it.
2. **The blind spot problem.** Students grind the topics they already like (arrays, easy problems) and quietly avoid what they are weak at (graphs, DP, system design). Without a record, weakness is invisible, until it shows up in the interview.
3. **The attribution problem.** Hours spent do not obviously connect to interview-readiness. It is very possible to solve a hundred easy problems and still fail on the topics that actually get tested.
4. **The variable time problem.** A recommendation that assumes three uninterrupted hours is useless on a night with thirty minutes between classes.
5. **The horizon problem.** Motivation is a poor engine over a multi-month prep timeline. Something has to carry the decision-making when motivation is not there.

## Core loop

```text
Goal → Skills → Mission → Progress → (back to Mission)
```

**Goal.** A long-horizon ambition with a stated reason it matters. Goals are never marked complete in a session. They have a horizon, not a due date.

**Skill.** A named capability a goal depends on, with a weight expressing how much that goal depends on it. Skills are shared across goals: "Swift" can serve both "become a strong software engineer" and "ship FORGE to the App Store", weighted differently by each.

**Mission.** One bounded unit of work with an explicit definition of done, an estimated time box, and a difficulty. A mission develops one primary skill and optionally touches secondary ones. Missions are proposed by FORGE and can be written by the user.

**Progress.** The append-only record of what was actually completed, plus the derived picture of proficiency computed from that record. Progress is an input to the next recommendation, not a decoration.

The loop closes when a completed mission changes the ranking of what gets recommended next. If that does not happen, FORGE is a todo list with extra steps.

## MVP

Everything below must exist for version 1 to be real. Nothing below is optional.

**Goals**
- Create a goal with a title and a short statement of why it matters
- View, edit, and archive goals
- Support a small number of concurrent goals, with one marked primary

**Skills**
- Create a skill and attach it to a goal with a weight
- Attach an existing skill to an additional goal
- View a skill's current proficiency estimate and the date it was last practiced

**Missions**
- Receive exactly one recommended mission at a time, with a plain-language explanation of why it was chosen
- State how much time is available and have the recommendation respect it
- Accept, skip, or replace the recommendation. A skip is recorded, because skips are signal
- Write a custom mission by hand
- Mark a mission complete, abandoned, or partially done

**Recording**
- On completion, record actual time spent, a self-rated difficulty, and an optional note
- Records are append-only and are never rewritten by the system

**Progress**
- See per-skill proficiency and practice history
- See the record of completed missions over time
- Understand at a glance which skills under the primary goal are being neglected
- See a daily practice streak as a plain fact, days practiced in a row, with no penalty animation or guilt copy when it breaks

**Platform baseline**
- Local persistence, working fully offline
- Dynamic Type, VoiceOver, and Reduce Motion supported throughout
- Light and dark appearance
- No account, no network dependency, no sign-in

## Non-goals

Deliberately excluded from version 1. Each of these is excluded for a reason, not because it was forgotten.

| Not in v1 | Why |
| --- | --- |
| CloudKit sync | One device is enough to validate the loop. Sync is a correctness problem that deserves its own phase. |
| Any AI or LLM feature | The deterministic recommender is the baseline a model has to beat. Building the model first means never knowing whether it helped. |
| Widgets, Live Activities, Watch app, App Intents | Surface area for a loop that is not yet proven. |
| Push notifications and reminders | Nagging is the easiest way to make someone delete an app. Earn attention before demanding it. |
| Points, badges, confetti, leaderboards, streak-loss guilt notifications | Manipulative engagement mechanics optimize for opening the app, not for interview readiness. A streak count is still in scope, see MVP, but only as an honest fact, not a dark pattern. |
| Social features, sharing, accountability partners | Different product. |
| A dashboard of charts | Any chart that does not change a decision is decoration. |
| A generic, user-authored-only mission system with no starter content | Students do not show up knowing what "DSA fundamentals" breaks down into. FORGE now ships a curated starter skill tree for CS fundamentals (arrays, hashing, trees, graphs, recursion, DP, and so on), the way Duolingo ships a language tree instead of a blank flashcard deck. Users can still add their own goals and skills on top of it. |
| Multiple users, accounts, or a backend | No server means no server problems. |
| Calendar or third-party integrations | Every integration is a permanent maintenance cost. |

## Future features

Candidates for later phases, in rough order of how likely they are to be worth it. None are commitments.

1. **Adaptive recommendation.** Learn from accept and skip patterns, estimation error, and completion rates. Any change here must beat the deterministic baseline on recorded history before it ships.
2. **Richer skill modeling.** A single proficiency number is a crude model. Confidence intervals, sub-skills, and decay rates that differ per skill are all plausible improvements.
3. **CloudKit sync.** Once one device works, multiple devices are worth the correctness cost.
4. **Widgets and Live Activities.** Today's mission on the home screen, and an in-progress mission in the Dynamic Island.
5. **App Intents and Siri.** "Start my mission" as a system-level verb.
6. **AI-assisted goal decomposition.** Turning a stated goal into a first draft of its skill tree is the single most tedious part of onboarding, and it is a good fit for a language model. On-device Foundation Models preferred, since the input is personal.
7. **Apple Watch.** Mission start and completion from the wrist.
8. **Honest analytics.** Momentum, consistency, and time invested per goal, shown only where they inform a decision.
9. **Spaced review.** Resurface a topic right before the recommender's proficiency model predicts it would decay, instead of waiting for the user to notice it has gone stale.

## Success criteria

FORGE is useful if, and only if:

1. **It gets used without prompting.** Its author opens it on at least five days a week for eight consecutive weeks, with no reminders, because it is the fastest way to answer "what now".
2. **Recommendations get accepted.** More than 60 percent of recommended missions are accepted rather than skipped or replaced. A high skip rate means the model of the user is wrong.
3. **It is fast enough to use in the moment.** From launch to knowing what to do takes under ten seconds.
4. **Progress survives scrutiny.** Given any skill, the app can show the concrete work that produced its current estimate, and that evidence is convincing to the person who did the work.
5. **It changes behavior.** Skills that were being neglected get practiced, and the user can name at least one thing they worked on specifically because FORGE told them to.

Explicit anti-criteria. FORGE is failing if session length goes up, if the user opens it out of obligation to a streak, or if the most-used screen is a chart.
