<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Some opinionated widgets that can be used for quickly developing Settings screen UI for Flutter apps.

## Usage

To use this package, add `some_settings_ui` as a
[dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Example

A simple usage example of the ```SliderDialogListTile``` widget:

```dart
SliderDialogListTile(
  title: const Text('A custom setting'),
  value: _customSettingValue,
  min: 2.0,
  max: 36.0,
  onChanged: (double value) => setState(() => _customSettingValue = value),
  onDisplayValue: (value) => '$value custom units',
),
```
