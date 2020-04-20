# dart_class_generator

A Flutter that can generate Dart classes. Runs on Android, Windows and Web. Check out the web app [here](https://groovinchip.github.io/dart_class_generator/#/)

### Notes:
- Plans for supported platforms include iOS and macOS.
- Release section will contain releases for supported platforms at the time of release.
- To run the Windows app:
  1. Download the zip file from the latest release
  2. Extract the zip
  3. Run the exe from inside the `runner` folder OR right-click the exe and create a shortcut to place anywhere you want
- If you find a bug or if you have a specific feature that you'd like to see implemented please file an issue. Thanks!

## Current Features:
- Create a Dart dynamically based on user input:
  - Choose the class name
  - Toggle a `const` constructor
  - Toggle `final` class members
  - Toggle named parameters
  - Add/remove as many class members as you want
  - Add dartdoc comments to the class name and every class member
  - Make any class member private or final
- Currently supports the following data types for class members:
  - `String`
  - `int`
  - `double`
  - `List<T>`
  - `Map<T, T>`
  - `DateTime`
  - Any custom type
- View the dynamically generated code and copy it to the clipboard. On Web/Desktop/Tablet you can create the class and see the generated code on the same screen. On mobile you will navigate to a separate view to see and copy the code.
- Toggle line numbers on or off for the code preview
- Toggle the code view from read-only to editable (note: the editable code view does not currently support copying, nor will the cursor accurately reflect where you have clicked. This will hopefully be resolved soon.)
- Set the preferred font size for the code preview

## Planned (in no particular order):
- MAJOR code refactor (I know its ugly and long and messy)
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

## Bugs/unwanted behavior
- `Divider` widgets do not show on web
- Backspacing the class name textfield until no characters are left crashes the code viewer
- Editable code view does not support selecting and copying code
- Editable code view does not accurately reflect the cursor location on web/windows
- Editable code view font size is not configurable
- Editable code view is broken for Windows
- Android intent to open directory containing downloaded code opens internal storage, not the directory within internal storage

