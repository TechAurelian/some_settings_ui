// Copyright 2022 TechAurelian. All rights reserved.
// Use of this source code is governed by a user license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// A [ListTile] that displays a title and a value, and allows the user
/// to change the value using radio list tiles that are displayed in a dialog.
///
/// When the user taps the list tile, the dialog is displayed. The user can
/// tap one of the radio tiles in the dialog to change the value.
///
/// ```dart
/// RadioDialogListTile<UuidVersion>(
///   title: const Text('A custom setting'),
///   options: _customSettingValues,
///   value: _customSettingValue,
///   onChanged: (value) => setState(() => _customSettingValue = value),
/// ),
/// ```
///
/// See also:
///
///  * [ListTile] and [AlertDialog], on which [RadioDialogListTile] is based.
class RadioDialogListTile<T> extends StatelessWidget {
  /// Creates a list tile that opens a dialog with radio list tiles when tapped.
  const RadioDialogListTile({
    super.key,
    this.title,
    required this.value,
    required this.options,
    this.cancelButton = const Text('Cancel'),
    this.onChanged,
  });

  static const String _valuePlaceholder = 'Select an option';

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// The current value, that is displayed in the subtitle of the list tile,
  /// and used as the currently selected radio list tile in the dialog.
  final T value;

  final Map<T, String> options;

  /// The child widget of the cancel button in the radio list dialog.
  ///
  /// Defaults to a Text widget that displays `Cancel`.
  final Widget cancelButton;

  /// Called when the user changes the value using the radio options displayed
  /// in the dialog.
  final ValueChanged<T>? onChanged;

  Future<void> _onListTileTap(BuildContext context) async {
    T? newValue = await _showRadioDialog(context);
    // Call the onChanged callback only if the value has been changed
    if (newValue != null && newValue != value) {
      onChanged?.call(newValue);
    }
  }

  Future<T?> _showRadioDialog(BuildContext context) {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: title,
          contentPadding: const EdgeInsets.only(top: 20.0, bottom: 24.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (MapEntry<T, String> option in options.entries)
                ListTile(
                  title: Text(option.value),
                  leading: Icon(
                    option.key == value ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: option.key == value ? Theme.of(context).toggleableActiveColor : null,
                  ),
                  contentPadding: const EdgeInsets.only(left: 24.0, right: 24.0 * 2),
                  onTap: () => Navigator.pop(context, option.key),
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: cancelButton,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: Text(options[value] ?? _valuePlaceholder),
      onTap: () => _onListTileTap(context),
    );
  }
}
