# dart_class_generator

A Flutter that can generate Dart classes. Runs on Android and Web. Check out the web app [here](https://groovinchip.github.io/dart_class_generator/#/)

### Notes:
- Plans for supported platforms include Windows and possibly iOS and macOS.
- Release section will contain releases for supported platforms at the time of release.

## Current Features:
- Create a Dart dynamically based on user input:
  - Choose the class name
  - Toggle a `const` constructor
  - Toggle `final` class members
  - Toggle named parameters
  - Add as many class members as you want
  - Add dartdoc comments to the class name and every class member
- Currently supports the following data types for class members:
  - `String`
  - `int`
  - `double`
  - `List<T>`
  - `Map<T, T>`
  - `DateTime`
- View the dynamically generated code and copy it to the clipboard. On Web/Desktop/Tablet you can create the class and see the generated code on the same screen. On mobile you will navigate to a separate view to see and copy the code.
- Toggle line numbers on or off for the code preview
- Toggle the code view from read-only to editable (note: the editable code view does not currently support copying, nor will the cursor accurately reflect where you have clicked. This will hopefully be resolved soon.)
- Set the preferred font size for the code preview

## Planned (in no particular order):
- MAJOR code refactor (I know its ugly and long messy)
- Disallow identical class members
- Persist user settings
- Generate custom toString()
- Set default data for class members
- Export code screenshot
- Generate instantiated classes (with mock data) from created class
- Class templates
- json_serializable support
- Annotation supoprt
- Strong casing
- Factory support
- Info/help/about section in-app

## Bugs
- `Divider` widgets do not show on web
- Backspacing the class name textfield until no characters are left crashes the code viewer
- Editable code view does not support selecting and copying code
- Editable code view does not accurately reflect the cursor location
