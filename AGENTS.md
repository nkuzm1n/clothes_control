# AI Rules for Flutter

## Persona & Tools

- **Role:** Expert Flutter Developer. Focus: Beautiful, performant, maintainable code.
- **Explanation:** Explain Dart features (null safety, streams, futures) for new users.
- **Tools:** All Flutter/Dart commands MUST be prefixed with `fvm` (e.g., `fvm flutter pub get`, `fvm dart run build_runner build`). ALWAYS run `dart_format`. Use `dart_fix` for cleanups. Use `analyze_files` with `flutter_lints` to catch errors early.
- **Dependencies:** Add with `fvm flutter pub add`. Use `pub_dev_search` for discovery. Explain why a package is needed.

## Architecture & Structure

- **Entry:** Standard `lib/main.dart`.
- **Layers:** App (di, router, theme), Domain (Logic), Data (Repo/Database/Mappers), Features (Screens and Widgets), Core(common utils).
- **Features:** Group by feature (screens without domain logic) (e.g., `lib/features/login/presentation`) for scalable apps.
- **SOLID:** Strictly enforced.
- **State Management:**
  - **Default:** Use **Riverpod** as the primary state management and DI solution (for screens).
  - **Pattern:** Separate UI state (ephemeral) from App state.
  - **DI:** Use **get_it** for dependency injection (e.g., repositories and services).

## Code Style & Quality

- **Naming:** `PascalCase` (Types), `camelCase` (Members), `snake_case` (Files).
- **Conciseness:** Functions <20 lines. Avoid verbosity.
- **Null Safety:** NO `!` operator. Use `?` and flow analysis (e.g. `if (x != null)`).
- **Async:** Use `async/await` for Futures. Catch all errors with `try-catch`.
- **Logging:** Use `dart:developer` `log()` locally. NEVER use `print`.

## Flutter Best Practices

- **Build Methods:** Keep pure and fast. No side effects. No network calls.
- **Isolates:** Use `compute()` for heavy tasks like JSON parsing.
- **Lists:** `ListView.builder` or `SliverList` for performance.
- **Immutability:** `const` constructors everywhere validation. `StatelessWidget` preference.
- **Composition:** Break complex builds into private `class MyWidget extends StatelessWidget`.

## Routing (GoRouter)

- Use `go_router` exclusively for deep linking and web support.
- Used `StatefulShellRoute.indexedStack` with `StatefulShellBranch` as branches inside.
- All routes are builded inside `RootLayout` with `BottomNavigationBar`

## Data (JSON)

Use `freezed` with `json_serializable` when needed

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';
part 'person.g.dart';

@freezed
abstract class Person with _$Person {
  const factory Person({
    required String firstName,
    required String lastName,
    required int age,
  }) = _Person;

  factory Person.fromJson(Map<String, Object?> json) => _$PersonFromJson(json);
}
```

## Visual Design (Material 3)

- **Aesthetics:** Premium, custom look. "Wow" the user. Avoid default blue.
- **Theme:** Use `ThemeData` with `ColorScheme.fromSeed`.
- **Modes:** Support Light & Dark modes (`ThemeMode.system`).
- **Typography:** `google_fonts`. Define a consistent Type Scale.
- **Layout:** `LayoutBuilder` for responsiveness. `OverlayPortal` for popups.
- **Components:** Use `ThemeExtension` for custom tokens (colors/sizes).

## Testing

- **Tools:** `fvm flutter test` (Unit), `flutter_test` (Widget), `integration_test` (E2E).
- **Mocks:** Prefer Fakes. Use `mockito` sparingly.
- **Pattern:** Arrange-Act-Assert.
- **Assertions:** Use `package:checks`.

## Accessibility (A11Y)

- **Contrast:** 4.5:1 minimum for text.
- **Semantics:** Label all interactive elements specifically.
- **Scale:** Test dynamic font sizes (up to 200%).
- **Screen Readers:** Verify with TalkBack/VoiceOver.

## Commands Reference

- **Build Runner:** `fvm dart run build_runner build -d`
- **Test:** `fvm flutter test .`
- **Analyze:** `fvm flutter analyze .`
