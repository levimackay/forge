# FORGE: Product Specification

Status: draft, Phase 0. This document defines what FORGE is for and what the first version must do. It will be revised as daily use of the core loop reveals what is actually true.

## User

The first user is one person: a computer science student with a long-horizon goal, limited and irregular free time, and no shortage of ambition. That person already knows roughly what they want to become. What they lack is a reliable way to convert that into the right forty minutes of work tonight.

Building for one real user with a real problem is deliberate. FORGE is designed to be used every day by its author before it is designed to be used by anyone else. A product that survives that test has a chance of being useful to a wider audience: anyone pursuing a difficult multi-year goal with self-directed practice. A product that does not survive it should not ship.

Who FORGE is not for, at least initially: teams, coaches managing other people, anyone looking for a general task manager, and anyone whose goals are already broken into an externally provided curriculum. If a syllabus already tells you what to do next, you do not need FORGE.

## Problem

Ambition is abstract. Action is concrete. The gap between them is where most self-directed improvement dies.

The specific failures FORGE targets:

1. **The translation problem.** "Get better at system design" does not tell you what to open. Doing that translation costs energy at exactly the moment you have the least of it.
2. **The blind spot problem.** People practice what they already enjoy and quietly avoid what they are weak at. Without a record, weakness is invisible.
3. **The attribution problem.** Hours spent do not obviously connect to goals reached. It is very possible to work hard for months in a direction that does not serve the stated goal.
4. **The variable time problem.** A recommendation that assumes three uninterrupted hours is useless on a night with thirty minutes.
5. **The horizon problem.** Motivation is a poor engine over a two-year timescale. Something has to carry the decision-making when motivation is not there.

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
| Streaks, points, levels, badges, confetti | Gamification optimizes for engagement, and engagement is not the goal. Evidence is. |
| Social features, sharing, accountability partners | Different product. |
| A dashboard of charts | Any chart that does not change a decision is decoration. |
| A prebuilt mission library or curriculum | The system has to work with missions the user cares about, not generic content. |
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

## Success criteria

FORGE is useful if, and only if:

1. **It gets used without prompting.** Its author opens it on at least five days a week for eight consecutive weeks, with no reminders, because it is the fastest way to answer "what now".
2. **Recommendations get accepted.** More than 60 percent of recommended missions are accepted rather than skipped or replaced. A high skip rate means the model of the user is wrong.
3. **It is fast enough to use in the moment.** From launch to knowing what to do takes under ten seconds.
4. **Progress survives scrutiny.** Given any skill, the app can show the concrete work that produced its current estimate, and that evidence is convincing to the person who did the work.
5. **It changes behavior.** Skills that were being neglected get practiced, and the user can name at least one thing they worked on specifically because FORGE told them to.

Explicit anti-criteria. FORGE is failing if session length goes up, if the user opens it out of obligation to a streak, or if the most-used screen is a chart.
