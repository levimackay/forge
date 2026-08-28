# FORGE: Design

Status: direction, Phase 0. This document is the visual and interaction specification. It is binding once implementation starts. Deviating from it means editing this file first, in its own commit, with the reason recorded.

## What FORGE should feel like

A record of serious work, kept carefully.

Not a game. Not a dashboard. Not a coach. The closest analogue is a well-made logbook: quiet, dense where it needs to be, blank where it does not, and built by someone who expected it to be read years later. Opening FORGE should feel like opening something that has been paying attention.

The eight properties the interface has to satisfy: native, minimal, premium, calm, focused, highly responsive, intentionally animated, accessible.

FORGE borrows Duolingo's structure, a daily habit loop over a skill tree that adapts to what you're weak at, not its visual language. No owl, no streak flame, no cartoon rewards. A calm, premium tool is what makes it credible to someone about to sit a technical interview rather than learn a language for fun.

## The one idea

**Heat is earned.**

The interface is almost entirely monochrome. There is exactly one warm accent, drawn from the forge metaphor, and it is reserved for the mission that is live right now. Nothing else in the app gets to use it. The result is that the single most important thing on screen is the only warm thing on screen, and the user's eye finds it without a single arrow, badge, or bounce.

This is the whole visual identity, and it is why FORGE does not need illustrations of anvils or hammers. The metaphor lives in the color logic, not in decoration.

## What FORGE must not become

| Avoid | Why |
| --- | --- |
| Gradient-heavy surfaces | Gradients are the fastest way to look like a template. Flat, considered surfaces age better. |
| XP, badges, confetti, mascots, leaderboards | Rewards the wrong thing, and reads as a kids' app to someone prepping for a job interview. Evidence of work is the reward. |
| A cluttered dashboard | Six numbers on a screen is six decisions deferred. |
| Generic AI product styling | Purple, glow effects, sparkle icons, and typing animations signal a category, not a product. |
| Cyberpunk, neon, terminal aesthetics | Loud, dated, and at odds with a product about sustained calm effort. |
| Gratuitous motion | Every animation costs time and attention. Most are not worth it. |
| Copying Apple's own app designs | Native means following the platform's principles, not cloning Journal or Fitness. |

The last one deserves care. FORGE should be unmistakably at home on iOS and unmistakably not an Apple app.

## Layout

**One decision per screen.** The primary screen answers "what now" with a single mission and a single primary action. Everything else on that screen is context for that one decision.

**Vertical rhythm from a single spacing scale.** A 4pt base with a limited set of steps. Whitespace is a structural element, not leftover room.

**Full-width division over cards.** Cards everywhere is the default look of an app assembled from components rather than designed. FORGE separates content with rules, weight changes, and space. Cards are used only where the metaphor is genuinely an object you could pick up, which in practice means a mission and almost nothing else.

**Corner radius is a signal, not a texture.** Most surfaces are square. The active mission surface has a radius. When one thing is rounded and nothing else is, the rounding means something.

## Typography

Type carries the hierarchy, because the palette will not.

**System font for prose.** SF Pro through the semantic text styles, which is what makes Dynamic Type work correctly. Weight and size do the work that color does in other apps.

**Monospaced for evidence.** Durations, counts, dates, proficiency values, and anything the user might scan or compare are set in SF Mono. Numbers that line up read as measured rather than asserted, and that is exactly the impression FORGE wants when it shows someone their record.

**Restraint in the scale.** A small number of defined roles: display, title, body, evidence, and metadata. If a new size is needed, one of the existing roles is wrong.

**Real hierarchy, not uniform bigness.** Large type is used where a screen has one thing to say, which on the primary screen is the mission itself. Elsewhere, small and confident beats large and shouting.

## Color

**Ground.** A near-neutral surface with a faint warm cast, in both light and dark appearance. Not pure white, not pure black. Pure white is clinical and pure black is a void, and neither reads as considered.

**Ink.** Two or three levels of foreground: primary, secondary, and a tertiary for metadata. Contrast between levels is what produces hierarchy in the absence of color.

**Heat.** One warm accent, in the ember range between deep amber and burnt orange. Its only job is the active mission and its primary action. It appears on at most one element at a time.

**No semantic color spray.** Success is not green and failure is not red, because completion and abandonment are both just facts in the record and neither one is a moral judgment. State is communicated with weight, position, and type, not with a traffic light.

Both appearances are designed, not derived. Dark mode is not the light palette inverted.

## Progress, shown honestly

The hardest design problem in FORGE. Progress must be visible and it must not become a score.

The rules:

1. **Show work, not points.** A skill's history is the list of what was actually done, in order, with real dates and real durations. That is more convincing than any number.
2. **Uncertainty stays visible.** A proficiency estimate built on four sessions is not the same as one built on forty, and the interface should not present them identically.
3. **No bar that fills to 100.** A completion bar implies a finish line that does not exist for a skill. Growth over time is a truer shape than a percentage.
4. **Neglect is information, not shame.** A skill untouched for three weeks is surfaced factually. No red, no alert, no guilt.
5. **Every chart earns its place.** If removing a visualization would not change any decision the user makes, remove it.

## Motion

Motion communicates state change and spatial relationship. Nothing else.

**What is animated:**

- Navigation transitions, where motion explains where a screen came from and how to get back.
- The transition from recommended to accepted to in progress, because that is the state change the whole app exists to produce.
- Mission completion. This is the one moment that gets a deliberately crafted animation, because it is the moment the user earned something. It should be brief, physical, and specific to FORGE. It should not be confetti.

**What is not animated:**

- List appearance, scroll-triggered reveals, and staggered fades.
- Numbers counting up.
- Anything decorative, anywhere.

**Timing.** Fast, in the 200 to 350 millisecond range, with spring curves that settle rather than bounce. Anything that makes the user wait for the interface has failed the ten-second requirement.

**Reduce Motion is a first-class path.** It is not the animation with the duration set to zero. Transitions become clean cross-fades, and the completion moment resolves as a state change instead of a movement. It is designed, and it is reviewed with the same eye as the default path.

## Haptics

Sparingly, and only where they map to something physical.

Accepting a mission and completing one both get haptic feedback, because both are commitments. Navigation, scrolling, and selection do not. Haptics used everywhere become noise and users turn them off, which costs the two moments where they were actually meaningful.

## Accessibility

Not a phase. A definition of done.

- Dynamic Type through the largest accessibility sizes, with layouts that reflow rather than truncate. Any layout that breaks at AX5 is broken.
- VoiceOver labels that read as sentences a person would say, with the mission justification available to screen reader users in the same form sighted users get.
- Contrast at WCAG AA minimum, verified in both appearances. The heat accent must clear contrast against the ground it sits on.
- Every action reachable without a gesture that requires precision or two hands.
- Reduce Motion, Reduce Transparency, Bold Text, and Increase Contrast all honored.
- Tap targets at 44pt minimum, without exception.

## Review

Any screen is judged against these questions before it is considered done:

1. What is the one thing this screen is for, and is that the largest, warmest, or most isolated element on it?
2. Could anything here be removed without the user losing information they act on?
3. Does it hold together at the default Dynamic Type size and at AX5?
4. Does it hold together in both light and dark appearance?
5. Does every animation on it communicate a state change?
6. Would this be recognizable as FORGE with the name removed?
7. Does it look designed, or does it look assembled from defaults?
