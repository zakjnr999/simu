---
trigger: always_on
---

# SIMU — IMPLEMENTATION & CODE QUALITY RULE

This rule governs how Simu frontend code must be implemented.

The goal is to keep the codebase production-ready as Simu grows into a large, highly interactive Flutter application.

---

## 1. IMPLEMENTATION PRINCIPLES

Write code that is:

- maintainable
- readable
- testable
- scalable
- strongly typed
- composable
- predictable

Prefer:

- composition over inheritance
- immutable state
- small focused classes
- small focused widgets
- explicit dependencies
- clear naming
- const constructors where possible
- final variables where possible
- reusable components

Avoid:

- giant widgets
- giant methods
- god classes
- duplicated code
- magic numbers
- unnecessary abstractions
- unnecessary dependencies
- unnecessary indirection
- hidden global state
- dead code
- premature optimization

---

# 2. SCREEN DEVELOPMENT WORKFLOW

When asked to build a new Simu screen, DO NOT immediately implement the entire UI.

Before writing the screen, determine:

1. Where the screen sits in the user flow.
2. What the primary user action is.
3. What secondary interactions exist.
4. What states the screen can have.
5. What data the screen requires.
6. What state the screen owns.
7. What reusable design-system components already exist.
8. What new reusable components are genuinely required.
9. What components are specific to the current feature.
10. What animations or transitions are required.
11. What navigation events exist.

Only then implement the screen.

The screen should be composed from smaller pieces rather than becoming one large widget.

---

# 3. COMPONENT REUSE IS MANDATORY

Before creating a new UI component:

1. Search the existing design-system components.
2. Determine whether an existing component can be reused.
3. Determine whether an existing component can be extended safely.
4. Only create a new component when the existing system does not adequately support the requirement.

Never duplicate an existing visual or interaction pattern.

Do not create variants such as:

- CustomPrimaryButton
- BetterPrimaryButton
- PrimaryButton2
- NewGameCard
- UniversalCard

when an existing component should be improved or reused.

Simu must evolve toward a coherent component system.

---

# 4. COMPONENT OWNERSHIP

Use this rule:

### Design-system component

Place a component in:

design_system/

when it is genuinely reusable across multiple features.

Examples:

- buttons
- selectable cards
- XP badges
- progress indicators
- mascot components
- achievement components
- generic loading states

### Feature-specific component

Place a component inside:

features/<feature>/presentation/widgets/

when its behavior or visual composition only makes sense inside that feature.

Do not move feature-specific components into the global design system simply because they look reusable.

Avoid creating a global dumping-ground folder such as:

shared/widgets/

unless there is a clearly justified architectural reason.

---

# 5. WIDGET RESPONSIBILITY

A widget should have one clear responsibility.

A screen may coordinate:

- layout
- state
- navigation
- interaction callbacks
- animation orchestration

But it should not contain:

- networking logic
- repository implementations
- complex business rules
- raw API parsing
- persistence logic

When a build method becomes difficult to understand, break the UI into meaningful components.

Do not split widgets arbitrarily just to make files smaller.

The goal is meaningful composition, not fragmentation.

---

# 6. BUSINESS LOGIC

Business logic must remain outside reusable UI components.

Reusable UI components should receive:

- data
- configuration
- callbacks

They should not know:

- which repository is being used
- how an API works
- how user progress is stored
- how AI requests are made
- how authentication works

Bad:

```dart
class StartSimulationButton extends ConsumerWidget {
  // directly calls repository/API
}