---
trigger: always_on
---

# SIMU — FLUTTER ARCHITECTURE RULE

This rule governs the technical architecture of the Simu Flutter project.

## ARCHITECTURAL PRINCIPLES

The project must prioritize:

- scalability
- maintainability
- testability
- feature isolation
- reusable components
- predictable state management
- separation of concerns
- strong typing
- minimal coupling

Use a feature-first architecture.

Do NOT organize the project primarily as:

screens/
widgets/
models/
services/

as a global dumping-ground structure.

## PROJECT STRUCTURE

Use this general structure:

lib/
├── app/
│   ├── app.dart
│   ├── router/
│   ├── theme/
│   └── config/
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── logging/
│   ├── result/
│   ├── services/
│   └── utils/
│
├── design_system/
│   ├── components/
│   ├── widgets/
│   └── design_system.dart
│
├── features/
│   ├── onboarding/
│   ├── home/
│   ├── practice/
│   ├── simulation/
│   ├── results/
│   ├── drills/
│   ├── progression/
│   ├── profile/
│   ├── settings/
│   └── auth/
│
└── main.dart

Each feature should be independently organized.

## FEATURE LAYERS

A feature should generally use:

presentation/
domain/
data/

### presentation
Contains:
- pages
- feature widgets
- providers
- controllers
- presentation state

### domain
Contains:
- entities
- repository contracts
- business rules
- use cases where justified

### data
Contains:
- API models
- DTOs
- datasources
- repository implementations
- mappers

Do not leak data-layer models into UI.

## STATE MANAGEMENT

Use Riverpod.

Prefer:
- Provider
- Notifier
- AsyncNotifier
- StreamProvider
- FutureProvider

State should be local to the feature that owns it.

Do not create one enormous global application state provider.

Simulation state must eventually support:
- turns
- responses
- AI responses
- timers
- retries
- hints
- interruption
- completion
- evaluation

Design this state explicitly.

## NAVIGATION

Use go_router.

Navigation must be centralized.

Prepare for:
- splash
- onboarding
- home
- practice
- scenario
- simulation
- results
- drills
- progression
- profile
- settings
- auth

Use route guards where required.

## DEPENDENCY DIRECTION

Dependencies should flow toward abstractions.

Presentation must not depend directly on:
- Dio
- database implementations
- storage implementations
- API DTOs

Widgets should not perform network requests directly.

## DOMAIN RULE

Business rules belong outside widgets.

Repositories are defined in domain and implemented in data.

## MODELS

Prefer immutable models.

Use Freezed where appropriate.

Use json_serializable for serialized data models.

Keep domain entities separate from transport models.

## ARCHITECTURAL DISCIPLINE

Avoid:
- god classes
- giant widgets
- giant providers
- global dumping-ground files
- unnecessary abstractions
- circular dependencies
- feature cross-coupling
- duplicated business logic

Prefer composition over inheritance.

## NEW FEATURE RULE

Before implementing a new feature:

1. Identify the feature boundary.
2. Identify its state.
3. Identify its domain entities.
4. Identify its repository contract.
5. Identify data requirements.
6. Identify reusable UI.
7. Implement presentation last.

Do not start by creating a giant screen widget.

## REUSE RULE

Reuse existing architecture before introducing new architecture.

If an existing abstraction already solves the problem, extend it instead of creating a competing abstraction.