# Sericulture Management

An offline-first mobile application foundation for managing Eri (*Samia ricini*) and *Bombyx mori* rearing. Android and iOS are supported from the start.

## Run locally

Install Flutter 3.38.5 or a compatible later stable release with Dart 3.10.4 or later, then run:

```sh
flutter pub get
flutter run
```

To configure the future API endpoint for a development build, pass `--dart-define=API_BASE_URL=<your-development-api-url>`. No API URL is required to launch the current UI foundation.

## Architecture

The app is organized by feature. Each feature can grow its own presentation, domain, and data layers. Shared app configuration, networking, errors, storage boundaries, theme, and widgets live under `lib/core/`. See [AGENTS.md](AGENTS.md) for architecture, offline-first, API, accessibility, and testing conventions.

## Local persistence decision

Drift/SQLite is the selected direction for persistent feature records. It provides mature migrations, transactions, typed queries, and a well-understood SQLite foundation across Android and iOS. No database package or schema has been added yet: storage should be introduced alongside the first real feature model and its migration rather than as an unused generated scaffold. Isar was not selected because its ecosystem and long-term maintenance path are less predictable for this project than SQLite-backed Drift.