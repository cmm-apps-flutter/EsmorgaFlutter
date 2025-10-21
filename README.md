# EsmorgaFlutter

## Environment execution

```
# QA (default)
flutter run -t lib/main.dart

# QA explícito
flutter run --dart-define=ESMORGA_ENV=qa -t lib/main.dart

# Producción
flutter run --dart-define=ESMORGA_ENV=prod -t lib/main.dart
```

For builds:
```
flutter build apk --dart-define=ESMORGA_ENV=prod -t lib/main.dart
flutter build ios --dart-define=ESMORGA_ENV=prod -t lib/main.dart
```

## Documentation
- Cubit architecture guidelines: `docs/cubit_architecture_guideline.md`
