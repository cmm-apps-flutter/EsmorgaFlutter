# Local Datasource with Hive CE

This folder contains the local storage implementation using Hive CE.

## Generating Hive Type Adapters

The Hive type adapters are generated using the `build_runner` package. 

To generate the adapters, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Or for continuous generation during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

This will generate the `event_local_model.g.dart` file which contains:
- `EventLocalModelAdapter`
- `EventLocationLocalModelAdapter`

## Structure

- `event_local_model.dart` - Hive model classes with annotations
- `event_local_model.g.dart` - Generated type adapters (do not edit manually)
- `event_local_datasource.dart` - Implementation of EventDatasource using Hive
- `mapper/event_local_mapper.dart` - Extensions to convert between local and data models

