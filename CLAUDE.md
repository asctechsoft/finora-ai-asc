# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Project Overview

**Finora (ASC Finance AI)** — Flutter personal-finance app: "Talk. Track. Plan. Live." Adaptive
by **Life Mode** (Solo / Dating / Living Together / Married / Family), voice-first Quick Add,
Safe-to-Spend dashboard, budgets, calendar, notifications. Package `com.asc.finora`, Firebase
project `finora-ai-fbb76`. Built from `ASC_Finance_AI_Full_App_Flow.docx` + Figma flow
(`figma-luồng/`). Architecture mirrors the `D:\smart_drink` reference app.

Phase 1 implements the ~25 Figma-designed screens wired with real GetX + sqflite. Remaining
spec screens (Household/split, Receipt OCR, AI Copilot, Forecast, Debt, Reports, Paywall…) are
stubbed — see `screen_placeholder/` and `Out of scope` in the plan.

## Commands

```bash
flutter pub get
flutter analyze --no-pub lib test    # scope to lib/test; dsp_base has its own lints
flutter run
flutter build apk --debug
flutter test
```

## Architecture

**State + routing:** GetX. Routes in `lib/values/app_pages.dart`, constants in
`lib/values/route_name.dart`. Permanent controllers bound in `main.dart` initialBinding
(`UserProfileController`, `QuickAddController`).

**Base package:** `dsp_base` (path dependency, internal ASC package copied from smart_drink).
Provides `commRunApp` (inits SharedPreferences via `PrefAssist`, localization, ads, Crashlytics),
`CommApp` (wraps GetMaterialApp), `PrefAssist` (note: `getBoolean`/`setBoolean`, not getBool).

**Layers:**
```
presentation/  screens + common_components
controller/    GetX reactive state
services/      seed_service, transaction_parser, storage/
repository/    finance_repository (single data-access point)
models/        data_models (sqflite-backed) + ui_models (enums, catalogs)
utils/         money_format, date_helper, life_mode_config
values/        app_colors, app_theme, route_name, app_pages
```

**Database:** SQLite `finora.db` (`services/storage/schema.dart`, singleton `DatabaseHelper`).
Tables: transactions, budgets, bills, goals, income_sources, notifications, wallets.
`SeedService.ensureSeeded()` populates demo data on first run (guarded by `PrefConst.demoSeeded`).

## Key patterns

- **Life Mode adaptivity:** one Home framework; `utils/life_mode_config.dart` maps each mode →
  hero label, KPI tiles, quick actions, bills (matches the 5 Figma Home variants). Tap the Home
  header chip to switch mode live.
- **Quick Add flow:** FAB → `QuickAddSheet` → Voice (`speech_to_text` + heuristic
  `TransactionParser` standing in for the AI Gateway) → Parsed Review → Save → Success + Undo.
  Manual path shares the same `QuickAddController.draft`.
- **Design tokens:** teal `#0D9488`, navy `#0F172A`, bg `#F8FAFC`, font PlusJakartaSans, cards
  radius 16–20. All in `values/app_colors.dart`.
- Models use `toMap`/`fromMap`/`copyWith`; `date_key` (YYYY-MM-DD) drives month queries.

## Conventions

- Dart SDK `^3.9.0`, Material 3, light theme only (Phase 1).
- minSdk **23** (Firebase requirement) — keep it in `android/app/build.gradle.kts`.
- AdMob test app id is in `AndroidManifest.xml` (dsp_base initializes ads).
- Localization scaffold: `lib/xml_strings/values` (en) + `values-vi` (vi); UI copy is currently
  inline English.
