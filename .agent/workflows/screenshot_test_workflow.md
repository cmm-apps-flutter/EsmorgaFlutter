---
description: How to implement and organize screenshot tests (Golden Tests)
---

# Screenshot Testing Workflow

This workflow describes the strategy for implementing screenshot tests using `mocktail`, `golden_screenshot`, and the project's `screenshot_helper.dart`.

## 1. Strategy

The goal is to capture **all valid UI states**. This involves:

1.  **Analyze Business Logic**: Examine the Cubit State and/or UI Mapper to identify all combinations of variables that affect the UI.
    *   *Example*: `isAuthenticated`, `isLoading`, `error`, `isFull`, `isDeadlinePassed`, etc.
2.  **Define Test Cases**: Create a list of scenarios covering these states.
3.  **Use `screenshotGolden`**: Utilize the helper function to run the test on defined devices.
4.  **Mock Dependencies**: Use `mocktail` to mock the necessary repositories or data sources. Ideally, pass a pre-configured Cubit or use a real Cubit with mocked data.
    *   *Recommendation*: Testing the **Screen** with a **Real Cubit** and **Mocked Repository** ensures the integration between Cubit logic and UI is also verified (state mapping).

## 2. Naming Convention

Screenshots should be named to clearly indicate the screen and the state being captured.

Format: `[screen_name]_[state_description]`

*   `screen_name`: snake_case name of the screen (e.g., `event_detail`).
*   `state_description`: concise description of the scenario (e.g., `loading`, `guest_view`, `user_joined`).

Examples:
*   `event_detail_loading`
*   `event_detail_guest`
*   `event_detail_user_joined`
*   `event_detail_error_network`

### 3. Avoid Loading States
- Do not create screenshot tests for loading states (e.g., circular progress indicators, skeletons).
- Focus on meaningful UI states (initial, content, empty, error).
- Loading animations can be flaky or visually inconsistent in golden tests.

## 4. Implementation Steps

1.  **Create Test File**: Create `test/view/[feature]/[screen]_screenshot_test.dart`.
2.  **Setup Mocks**: Define mocks for Repositories/use-cases needed by the Cubit.
3.  **Define Scenarios**:
    ```dart
    screenshotGolden(
      'event_detail_guest_view',
      devices: [Device.phone, Device.tablet], // Select appropriate devices
      theme: AppTheme.light, // Or relevant theme
      screenshotPath: 'event_detail'
      buildHome: () {
        // Setup mock behavior for this scenario
        when(() => mockRepo.getData()).thenAnswer((_) async => ...);
        
        // Return the screen wrapped in necessary providers
        return BlocProvider(
          create: (_) => MyCubit(repo: mockRepo)..start(),
          child: MyScreen(),
        );
      },
    );
    ```
4.  **Run Tests**: `flutter test --update-goldens` (or appropriate command to generate).

## 4. Specific Considerations for Esmorga

*   **Localization**: Ensure `LocalizationService` is mocked or initialized if implied by the `screenshot_helper`.
*   **Images**: Use `mocktail_image_network` if network images are present, or ensure empty states are handled.