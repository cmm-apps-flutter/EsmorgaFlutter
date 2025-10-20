# Cubit Architecture Guidelines

This guideline formalizes how to implement Cubit in this project, using the existing `register_cubit` as the canonical minimal example. It complements (and eventually can replace) the legacy `BLOC_ARCHITECTURE.md` at the repository root.

---
## 1. Core Principles

Flow (unidirectional):
```
User Action → Method call on Cubit → Cubit (business logic + orchestration) → State → UI (renders + side‑effects)
```
A Cubit MUST:
- Expose imperative methods (e.g. `submit`, `updateEmail`) and emit states only.
- Contain pure orchestration / business rules (no UI, no navigation, no imperative side‑effects like SnackBars).
- Be framework‑agnostic (no direct `BuildContext`).
- Be easily testable (inject dependencies, mock them in tests).

A Cubit MUST NOT:
- Perform navigation (`Navigator`, `go_router`, custom routers) directly.
- Show UI elements (SnackBar/Dialog) directly.
- Reach outside through additional `StreamController`s for side‑effects.
- Depend on widgets or platform channels directly.

---
## 2. Folder & File Structure (Per Feature)
```
lib/
  view/<feature>/
    cubit/
      <feature>_cubit.dart
      <feature>_state.dart
    view/
      <feature>_screen.dart
    widgets/ (optional reusable UI pieces)
```
Keep one logical concern per file: cubit (imperative methods) and state (immutable state container or sealed states).

---
## 3. State Modeling Strategies
We support two approved strategies—choose deliberately:

### Strategy A: Finite State Classes (Simple / Linear Flows)
Use mutually exclusive classes like `Initial`, `Loading`, `Success`, `Failure`.
Best for: single-shot operations (register, resend verification, submit form without granular field errors).
Pros: very explicit, minimal boilerplate. Cons: does not scale well to multiple simultaneous flags / field-level errors.

### Strategy B: Single Data State (State Container)
Single immutable class with fields + `copyWith()` + `Equatable`.
Best for: complex forms (per-field errors), lists with filters, combined loading flags.
Pros: scalable and composable. Cons: slightly more boilerplate.

Heuristic:
- If you foresee more than 2 independent flags or per-field errors, start with Strategy B.
- Otherwise begin with Strategy A; migrate later if complexity grows.

---
## 4. Canonical Example: Registration (Strategy A)

`register_state.dart`
```dart
abstract class RegisterState {}
class RegisterInitial extends RegisterState {}
class RegisterLoading extends RegisterState {}
class RegisterSuccess extends RegisterState { final String email; RegisterSuccess(this.email); }
class RegisterFailure extends RegisterState { final String error; RegisterFailure(this.error); }
```

`register_cubit.dart`
```dart
class RegisterCubit extends Cubit<RegisterState> {
  final UserRepository userRepository;
  final RegistrationValidator validator;

  RegisterCubit({
    required this.userRepository,
    required this.validator,
  }) : super(RegisterInitial());

  Future<void> submit({
    required String name,
    required String lastName,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());

    final validationError = validator.validateAll(
      name: name,
      lastName: lastName,
      email: email,
      password: password,
    );
    if (validationError != null) {
      emit(RegisterFailure(validationError));
      return;
    }

    try {
      await userRepository.register(name, lastName, email, password);
      emit(RegisterSuccess(email));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
```

UI extract (registration button & side‑effects):
```dart
BlocListener<RegisterCubit, RegisterState>(
  listener: (context, state) {
    if (state is RegisterSuccess) {
      context.nav.toRegistrationConfirmation(state.email);
    } else if (state is RegisterFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
  },
  child: BlocBuilder<RegisterCubit, RegisterState>(
    builder: (context, state) {
      final isLoading = state is RegisterLoading;
      return EsmorgaButton(
        text: l10n.buttonRegister,
        isLoading: isLoading,
        onClick: () => context.read<RegisterCubit>().submit(
          name: _nameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    },
  ),
);
```

Why Strategy A fits here:
- Linear flow: idle → loading → success/failure.
- No per-field error display (single error surface).
- Only one asynchronous operation per submission.

Migration trigger to Strategy B:
- Need to persist partial form validation state per field (e.g. `nameError`, `emailError`).
- Need additional flags (e.g. `isCheckingEmail`, `isTermsAccepted`).

---
## 5. Method Naming & Semantics
Pattern: Use descriptive method names expressing user intent or completed actions (`submit`, `emailChanged`, `retry`). Keep method names short and explicit.

DO:
- `submit`, `emailChanged`, `retry`

AVOID:
- `doRegister`, `tapButton`, `process` (ambiguous or UI-tied)

Split methods when they trigger different logic branches; avoid giant methods bundling unrelated concerns.

---
## 6. Validation Strategy
Local validation (synchronous) should occur inside Cubit before calling repositories. Use a dedicated validator class (e.g. `RegistrationValidator`) injected into the Cubit for testability.

Pattern:
```dart
final error = validator.validateAll(...);
if (error != null) {
  emit(RegisterFailure(error));
  return;
}
```
If per-field errors are needed, switch to State Container with individual error fields.

---
## 7. Navigation & Side Effects
Never inside the Cubit. The UI layer (Widget) reacts to states using:
- `BlocListener` (pure side effects)
- `BlocBuilder` (rendering)
- `BlocConsumer` (both, when coupling is acceptable)

Use an `AppNavigator` abstraction when navigation patterns repeat, to keep route construction centralized.

---
## 8. Dependency Injection
Provide repositories / validators through constructor. Example provider:
```dart
BlocProvider(
  create: (context) => RegisterCubit(
    userRepository: context.read<UserRepository>(),
    validator: context.read<RegistrationValidator>(),
  ),
  child: const RegisterScreen(),
);
```
If using a DI container (e.g. `get_it`), wrap access via `context.read()` or a factory to simplify tests.

---
## 9. Testing Guidelines
Use `bloc_test` package; it supports testing Cubits as well.

Happy path:
```dart
blocTest<RegisterCubit, RegisterState>(
  'emits [Loading, Success] when registration succeeds',
  build: () => RegisterCubit(
    userRepository: mockUserRepository,
    validator: mockValidator,
  ),
  setUp: () {
    when(() => mockValidator.validateAll(
      name: any(named: 'name'),
      lastName: any(named: 'lastName'),
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenReturn(null);
    when(() => mockUserRepository.register(any(), any(), any(), any()))
      .thenAnswer((_) async {});
  },
  act: (cubit) => cubit.submit(
    name: 'John', lastName: 'Doe', email: 'a@b.com', password: '12345',
  ),
  expect: () => [isA<RegisterLoading>(), isA<RegisterSuccess>()],
);
```

Validation failure:
```dart
blocTest<RegisterCubit, RegisterState>(
  'emits [Loading, Failure] when local validation fails',
  build: () => RegisterCubit(
    userRepository: mockUserRepository,
    validator: mockValidator,
  ),
  setUp: () {
    when(() => mockValidator.validateAll(
      name: any(named: 'name'),
      lastName: any(named: 'lastName'),
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenReturn('Invalid email');
  },
  act: (cubit) => cubit.submit(
    name: 'John', lastName: 'Doe', email: 'bad', password: '12345',
  ),
  expect: () => [
    isA<RegisterLoading>(),
    isA<RegisterFailure>().having((s) => s.error, 'error', 'Invalid email'),
  ],
  verify: (_) => verifyNever(() => mockUserRepository.register(any(), any(), any(), any())),
);
```

Repository failure:
```dart
blocTest<RegisterCubit, RegisterState>(
  'emits [Loading, Failure] when repository throws',
  build: () => RegisterCubit(
    userRepository: mockUserRepository,
    validator: mockValidator,
  ),
  setUp: () {
    when(() => mockValidator.validateAll(
      name: any(named: 'name'),
      lastName: any(named: 'lastName'),
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenReturn(null);
    when(() => mockUserRepository.register(any(), any(), any(), any()))
      .thenThrow(Exception('Network error'));
  },
  act: (cubit) => cubit.submit(
    name: 'John', lastName: 'Doe', email: 'a@b.com', password: '12345',
  ),
  expect: () => [
    isA<RegisterLoading>(),
    isA<RegisterFailure>().having((s) => s.error, 'error', contains('Network error')),
  ],
);
```

---
## 10. Evolution & Refactoring Guidance
| Scenario | Action |
|----------|--------|
| Add per-field errors | Migrate to State Container (Strategy B) |
| Add multi-step wizard | Either keep Strategy A with more explicit states (`Step1Completed`) or adopt hybrid: container state + enum step |
| Need cancellation / concurrency | Use `emit` guard patterns or `restartable()` transformers (see advanced section TBD) |
| Need periodic refresh | Isolate timer in repository/service; Cubit listens via method calls triggered by UI or other services |

---
## 11. Common Anti‑Patterns (Avoid)
| Anti‑Pattern | Why Bad | Fix |
|--------------|---------|-----|
| Holding `BuildContext` in Cubit | Couples to UI layer | Move usage to UI listener |
| Emitting same mutable state instance | Breaks change detection | Use new immutable instance / `copyWith()` |
| Navigation inside Cubit methods | Hard to test, side‑effect in logic | Emit state; UI reacts |
| Multiple unrelated concerns in one Cubit | Low cohesion | Split by feature or responsibility |
| Silent catch (swallow errors) | Debugging nightmare | Always emit a failure state |

---
## 12. Checklist for a New Cubit (PR Review Aid)
- [ ] Files: `<feature>_cubit.dart`, `<feature>_state.dart` created
- [ ] Strategy A or B explicitly justified in PR description
- [ ] No direct navigation / UI side‑effects inside Cubit
- [ ] Dependencies injected via constructor (no service locator calls inside methods)
- [ ] All async paths emit a terminal state (success or failure)
- [ ] Tests cover success + failure + at least one validation/error branch
- [ ] Method names are explicit and reflect intent
- [ ] No unused methods or states
- [ ] Errors surfaced as data (never `print()` only)

---
## 13. Future Extensions (Planned Section Stubs)
(Add when needed)
- Advanced transformers / concurrency helpers (`droppable`, `restartable`, `sequential`)
- Caching strategies & hydration
- Debouncing / throttling user input
- Multi-Cubit coordination patterns

### 13.1 Ephemeral Side-Effects with Transient States
Earlier we used a container state with `lastAction + actionId` (e.g. in `RegistrationConfirmationState`) to trigger one-off effects. This has been migrated to a simpler finite state approach where the Cubit briefly emits a transient side-effect state (e.g. `RegistrationConfirmationOpenEmailApp`, `RegistrationConfirmationResendSuccess`, `RegistrationConfirmationResendFailure`) and then returns to `RegistrationConfirmationInitial`.

Pattern:
```dart
emit(RegistrationConfirmationOpenEmailApp());
emit(RegistrationConfirmationInitial());
```
Pros:
- Removes bookkeeping fields (`actionId`, `lastAction`).
- Each side-effect is explicit via type matching.
Cons:
- Emits an extra rebuild (usually negligible). If performance becomes critical, revert to a data flag + `listenWhen`.
Migration Rule:
- Use transient states when the number of distinct side-effects is small and mutually exclusive.
- Use a container state with an incrementing token ONLY if you need to fire the same side-effect type multiple times rapidly and must differentiate them.

---
## 14. Quick Start Template (Strategy B)
(Use when complexity > simple linear submit)
```dart
class FeatureState extends Equatable {
  final bool isLoading;
  final String? error;
  final String formValue;
  const FeatureState({ this.isLoading = false, this.error, this.formValue = '' });
  FeatureState copyWith({ bool? isLoading, String? error, String? formValue }) => FeatureState(
    isLoading: isLoading ?? this.isLoading,
    error: error,
    formValue: formValue ?? this.formValue,
  );
  @override List<Object?> get props => [isLoading, error, formValue];
}
```

---
## 15. Summary
Use the simplest viable state modeling approach; keep Cubits pure and free of UI concerns; surface all outcomes via states; write focused tests; migrate to more expressive state patterns only when justified by feature growth.

> When in doubt: Start with Strategy A (finite classes), add tests, and document when you outgrow it.

---
Maintainers: Update this guideline whenever a new reusable pattern (e.g. debounced search, cancellable operations) solidifies in the codebase.

