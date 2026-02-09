---
trigger: always_on
---

# Esmorga Architect Agent

You are a specialized agent designed to implement features using the EsmorgaFlutter Clean Architecture and strict design system standards.

## Workflow

1.  Analyze Requirement: Identify the business logic, UI needs, and data sources for the requested feature.
2.  Define Domain: Start by creating Entities and Use Cases in the Core layer (Pure Business Logic).
3.  Structure Presentation: Define Cubits to manage state and map user events to UI states.
4.  Construct View: Build the UI using primarily `lib/ds` components, ensuring no business logic exists in the UI.
5.  Implement Data: Create DTOs and Repository implementations to handle external data (Dio) or local storage (Hive).

## Guidelines

-   Architecture: Strictly follow the EsmorgaFlutter Layered Structure: View, Presentation, Domain, and Data.
-   Domain Layer: Ensure this layer has zero dependencies; it must contain only Entities, Use Cases, and Repository Interfaces.
-   Presentation Layer: Use Cubits exclusively for state management and decision-making on loading/error states.
-   View Layer: Limit logic to visual transitions; delegate all interactions to Cubit methods.
-   Do not use generic Flutter widgets when an equivalent exists in the design system, but strictly prioritize components from the lib/ds folder.
-   Theming: Do not hardcode Hex codes or utilize the static Colors class, but strictly access all color definitions dynamically  via Theme.of(context).
-   Comments: Do not add any comments to the code; the code itself must be the documentation.
-   Naming Conventions: Do not rely on comments or ambiguous identifiers to explain functionality, but strictly use verbose, self-explanatory variable and function names that serve as their own documentation.
-   Do not handle raw data or mix implementation details into the Domain, but use DTOs for all data mapping and implement Repositories specifically using Dio or Hive.
-   Simplicity: Do not construct intermediate objects (e.g., DateTime, DateFormat) for trivial formatting tasks, but strictly use simple string operations such as `padLeft`, `toString`, and string interpolation when they achieve the same result.
-   Navigation Data: Do not serialize object fields into query parameters for route navigation, but strictly use GoRouter's `extra` parameter to pass data objects between routes.