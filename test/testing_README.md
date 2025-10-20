For execute the tests with coverage use

`flutter test --coverage`

Then a /coverage folder will be created with a .info file.

Install lcov to generate a html report
`brew install lcov`

Then transform the .info file to an html report

`genhtml coverage/lcov.info -o coverage/html`

Finally open the html file

---
## Bloc Testing Standard

All Bloc tests should follow these guidelines:

1. Source location convention: production Bloc classes must live under `lib/view/<feature>/bloc/`. Tests go under `test/view/<feature>/` and follow the `<bloc_name>_bloc_test.dart` naming. (If legacy blocs still exist outside this path, schedule a refactor to move them into the view feature folder.)
2. Use `bloc_test` for sequence testing. Prefer expressive `having` matchers instead of relying solely on concrete state classes unless those classes are sealed hierarchies.
3. Each Bloc must have at minimum:
   - A happy path test (success scenario).
   - An error scenario test (repository/validation failure).
   - Validation / early-return test (when applicable for form blocs).
   - Effect / one-off emission test (if Bloc exposes effects via state or streams).
4. Mock external dependencies only. Keep value objects (models) real where practical for readability.
5. Prefer real validators & localizations unless stubbing is required to force edge cases quickly.
6. When UI mapping depends on singletons (e.g. date formatter via `getIt`), register a fake in the test `setUp` (`ensureFakeDateFormatter()` helper provided in `test/helpers/test_utils.dart`).
7. Keep artificial delays small (`5-10 ms`) only when awaiting async handlers before dispatching a follow-up event in the same `act` callback.
8. Avoid brittle time-based expectations. Do not assert on `DateTime.now()` outputs; focus on logical flags and data transformations.
9. For effect pattern via separate streams (e.g. `EventBloc.effects`), collect effects by attaching a listener and asserting on the resulting list.
10. Use `verifyNever` / `verify` to ensure repositories are (not) called on validation failures.

### Bloc Location Convention
- Path pattern: `lib/view/<feature>/bloc/<name>_bloc.dart` (+ part files in same folder).
- Feature folder name should describe a user-facing screen or flow (`event_detail`, `change_password`, `login`, etc.).
- Domain or shared logic extracted into services/repositories remains in `lib/domain/...`, but Bloc orchestration stays in `lib/view` to clarify presentation layer ownership.
- When migrating legacy blocs (e.g., ones currently in `lib/domain/event/`), update all imports in tests and widgets and run the test suite.

### Utilities
- `test/helpers/test_utils.dart` supplies:
  - `testL10n()` English localization
  - `testValidator()` real validator with English strings
  - `ensureFakeDateFormatter()` registers a predictable formatter

### Adding a New Bloc Test Checklist
- [ ] Identify repository & service dependencies and create mocks.
- [ ] Prepare minimal model fixtures (real objects, not mocks).
- [ ] Register any required singletons (formatter, etc.).
- [ ] Write success test.
- [ ] Write failure test (generic + network specific if logic diverges).
- [ ] Write validation test (for form blocs) ensuring no repo calls on invalid form.
- [ ] Write effect/emission test (navigation, snackbars, etc.).
- [ ] Run `flutter test` locally and ensure all pass.

### Naming Conventions
Test descriptions should read like behavior statements:
`'emits submitting then success when change succeeds'`
`'emits failure with network flag when network error'`

This clarifies trigger, sequence, and condition.
