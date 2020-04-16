# dart_class_generator

A Flutter that can generate Dart classes. Runs on Android and Web. Check out the web app at [link]

### Notes:
- Plans for supported platforms include Windows and possibly iOS and macOS.
- Release section will contain releases for supported platforms at the time of release.

## Current Features:
- Create a Dart dynamically based on user input. Choose the class name, toggle a `const` constructor, toggle `final` class members, and add as many class members as you want.
- Currently supports the following data types for class members:
  - `String`
  - `int`
  - `double`
  - `List<T>`
  - `Map<T, T>`
  - `DateTime`
- View the dynamically generated code and copy it to the clipboard. On Web/Desktop you can create the class and see the generated code on the same screen. On mobile you will navigate to a separate view to see and copy the code.
- Toggle line numbers on or off for the code preview
- Set the preferred font size for the code preview

## Planned (in no particular order):
- MAJOR code refactor (I know its ugly and long messy)
- Toggle named parameters
- Disallow identical class members
- Support for custom dartdoc comments
- Persist user settings
- Generate custom toString()
- Set default data for class members
- Export code screenshot
- Tablet UI support
- Generate instantiated classes (with mock data) from created class
- Class templates
- json_serializable support
- Annotation supoprt
- Strong casing
- Factory support
- Info/help/about section in-app

## Bugs
- Copying code to the clipboard does not work on Windows
- `Divider` widgets do not show on web
- Backspacing the class name textfield until no characters are left crashes the code viewer
