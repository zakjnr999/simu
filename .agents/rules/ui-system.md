---
trigger: always_on
---

# SIMU — UI SYSTEM RULE

This rule governs all Simu UI, component creation, screen implementation, interaction design, animation, typography, and visual composition.

## UI IS A SYSTEM

Simu must be built as a reusable UI system, not as a collection of independently designed screens.

Before creating a UI element ask:

1. Does this pattern already exist?
2. Can an existing component be reused?
3. Should this become a reusable design-system component?
4. Is this specific to one feature?

Never duplicate an existing design pattern.

---

## COMPONENT OWNERSHIP

Global reusable components belong in:

design_system/

Feature-specific components belong in:

features/<feature>/presentation/widgets/

Do NOT create a global dumping ground such as:

shared/widgets/

unless there is a specific architectural reason.

---

## REUSABLE COMPONENTS

The system should gradually provide reusable components such as:

- SimuScaffold
- SimuPageHeader
- SimuSectionHeader
- SimuPrimaryAction
- SimuSecondaryAction
- SimuGameCard
- SimuSelectableCard
- SimuLockedCard
- SimuRewardCard
- SimuXpBadge
- SimuLevelBadge
- SimuProgressBar
- SimuProgressPath
- SimuCheckpoint
- SimuAchievementBadge
- SimuChoiceTile
- SimuDifficultyIndicator
- SimuSkillMeter
- SimuMascot
- SimuMascotBubble
- SimuMascotReaction
- SimuAnimatedCounter
- SimuLoadingState
- SimuEmptyState
- SimuErrorState

Only create components when there is a real reuse case.

Do not build abstractions for hypothetical future requirements.

---

## SCREEN COMPOSITION

Complex screens must be composed from smaller components.

Avoid giant build methods.

A screen should primarily orchestrate:

- layout
- state
- interactions
- navigation
- animation

A screen should NOT become the place where reusable visual patterns are reinvented.

---

# TYPOGRAPHY SYSTEM

Typography is a core part of Simu's brand identity.

The approved Simu typography system is:

## DISPLAY / BRAND FONT

Use:

**Fredoka**

Fredoka is Simu's primary expressive display typeface.

Use Fredoka for:

- hero headings
- major screen titles
- large section headings
- level names
- XP numbers
- reward numbers
- achievement titles
- game-like labels
- prominent interactive actions
- playful onboarding copy

Fredoka should communicate:

- friendly
- rounded
- playful
- energetic
- premium
- approachable

Major typography should feel distinctive and not like default Flutter UI text.

Approved Fredoka weights:

- Regular
- Medium
- SemiBold
- Bold

Prefer:
- SemiBold for most prominent UI
- Bold for major headings and reward moments
- Medium for supporting display text
- Regular only where a lighter display treatment is genuinely useful

Do not use every weight simply because it exists.

---

## BODY / INFORMATION FONT

Use:

**Nunito Sans**

Nunito Sans is Simu's secondary typeface for readable information-heavy content.

Use Nunito Sans for:

- body text
- descriptions
- scenario instructions
- explanatory text
- supporting content
- small metadata
- accessibility-heavy content
- long-form text
- secondary labels

Approved Nunito Sans weights:

- Regular
- Medium
- SemiBold
- Bold

General usage:

Regular:
normal body copy

Medium:
slightly emphasized supporting text

SemiBold:
important labels / metadata

Bold:
strong emphasis where required

---

## TYPOGRAPHY HIERARCHY

Establish a centralized typography system with tokens such as:

- displayLarge
- displayMedium
- displaySmall
- headlineLarge
- headlineMedium
- headlineSmall
- titleLarge
- titleMedium
- titleSmall
- bodyLarge
- bodyMedium
- bodySmall
- labelLarge
- labelMedium
- labelSmall
- xp
- reward
- badge

The exact font size and line height values must be centralized in the Simu typography system.

Do NOT repeatedly create raw TextStyle values inside individual screens.

Bad:

```dart
TextStyle(
  fontSize: 42,
  fontWeight: FontWeight.bold,
)