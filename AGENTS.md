# Project instructions

## Purpose and platforms

- Build a sericulture management app for Eri (*Samia ricini*) and *Bombyx mori* rearing.
- Android and iOS are first-class supported mobile platforms. Keep shared Flutter code portable across both.
- Current screens are a navigable foundation only; do not imply that placeholder forms or features persist or communicate with a server.

## Architecture and folders

- Organize code feature-first under `lib/features/<feature>/`.
- Keep feature-specific UI in `presentation/`, business rules and entities in `domain/`, and persistence/network adapters in `data/` as each feature is implemented. Do not create empty directories or layers without a use case.
- Put cross-cutting configuration, errors, networking, storage contracts, theme, and reusable widgets under `lib/core/`.
- Keep app startup, dependency composition, and route configuration under `lib/app/`; `lib/main.dart` should remain a small bootstrap.
- Repositories coordinate domain use cases and data sources. Keep widgets focused and extract repeated presentation patterns into `lib/core/widgets/`.

## Design system

- Use Material 3 and the shared theme in `lib/core/theme/`. Prefer theme colors and typography over local hard-coded styling.
- Use `AppSpacing` and shared controls/cards/states to maintain consistent touch targets, spacing, corner radii, and visual hierarchy.
- Support system light/dark mode and responsive layouts. Provide meaningful labels, accessible contrast, semantic feedback, and keyboard-appropriate input types.

## Offline-first and persistence

- Local data is the source of truth for user-created and edited records. UI must remain useful without network connectivity.
- Selected persistence direction: Drift/SQLite. Add it with the first real feature schema and migration; do not add unused persistence dependencies or generated code in advance.
- Repository writes go to local storage first. Network synchronization is a separate, explicit concern that must define retry behavior, conflict resolution, and deletion semantics before implementation.
- Do not add a fake sync engine, mock successful persistence, or present remote data as available when it is not.

## API integration

- Use `ApiConfig` and the shared `ApiClient` for future HTTP access. Configure endpoints through `API_BASE_URL` (`--dart-define`) per environment.
- Never commit credentials, access tokens, private keys, or production URLs. Do not bake environment-specific endpoints into features.
- Keep transport DTOs/adapters in feature data layers and translate transport failures into safe, actionable UI states. Do not expose secrets or raw server internals in errors.
- The future service is expected to be a Node.js/Express REST API backed by MongoDB Atlas; do not couple mobile code to database-driver details.

## Quality and safety

- Preserve sound null safety; validate and normalize user input at domain boundaries, not only in widgets.
- Handle loading, empty, offline, validation, and error states explicitly. Avoid swallowing errors or silently discarding user edits.
- Do not hardcode production, customer, farm, or batch data. Placeholder screens must be clearly identified and must not fabricate backend behavior.
- Add unit tests for domain rules and data/repository behavior, widget tests for important user flows and accessibility semantics, and integration tests for critical workflows as they are implemented.
- Run `dart format` on changed Dart files, `flutter analyze`, and relevant tests before considering a change complete.