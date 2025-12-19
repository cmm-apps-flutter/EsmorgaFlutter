# Flow Visualizer Layout Rules (STRICT)

These rules define the visual language of the Flow Visualizer. They must be followed strictly to ensure consistency and readability.

## 1. flow Orientation
*   **Horizontal Layout**: All flows MUST be laid out horizontally.
*   **Progression**: User progression is ALWAYS **Left → Right**.
*   **Vertical Prohibition**: Vertical layouts inside a flow are NOT allowed.

## 2. Swimlanes
*   **Vertical Stacking**: Swimlanes (Flows) are stacked vertically.
*   **Horizontal Bands**: Each swimlane occupies a horizontal band.
*   **Containment**: No flow may expand vertically beyond its allocated swimlane height.

## 3. Primary Path
*   **Entry Point**: The Entry screen is placed at the far **Left** of the swimlane.
*   **Main Axis**: Main progression advances strictly to the Right.

## 4. Branching
*   **Vertical Distribution**: Secondary screens branch slightly **Up or Down** relative to the main node.
*   **Rejoining**: Branches MUST rejoin the horizontal axis eventually.
*   **No Vertical Flows**: Branches must never become vertical chains; they represent parallel horizontal paths.

## 5. Return Paths & Loops
*   **Routing**: Must route **Above or Below** the main path (Bottom-hugging preferred).
*   **Direction**: Never visually reverse the primary Left → Right direction (use U-shaped returns).

## 6. Explicit Anti-Patterns (DO NOT DO)
*   ❌ Do NOT stack screens vertically to represent progression.
*   ❌ Do NOT place entry screens at the top.
*   ❌ Do NOT use top-to-bottom reading as the main flow direction.
*   ❌ Do NOT represent flows as vertical columns.
