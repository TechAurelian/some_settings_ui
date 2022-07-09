// Copyright 2022 TechAurelian. All rights reserved.
// Use of this source code is governed by a user license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// A [ListTile] that displays a title and a numeric value, and allows the user
/// to change the value using a [Slider] that is displayed in a dialog.
///
/// When the user taps the list tile, the dialog is displayed. The user can
/// drag the slider and tap the OK button to change the value.
///
/// ```dart
/// SliderDialogListTile(
///   title: const Text('A custom setting'),
///   value: _customSettingValue,
///   min: 2.0,
///   max: 36.0,
///   onChanged: (double value) => setState(() => _customSettingValue = value),
///   onDisplayValue: (value) => '$value custom units',
/// ),
/// ```
///
/// See also:
///
///  * [ListTile] and [Slider], on which [SliderDialogListTile] is based.
class SliderDialogListTile extends StatelessWidget {
  /// Creates a list tile that opens a dialog with a slider when tapped.
  const SliderDialogListTile({
    super.key,
    this.title,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.okButton = const Text('OK'),
    this.cancelButton = const Text('Cancel'),
    this.onChanged,
    this.onDisplayValue,
  })  : assert(min <= max),
        assert(value >= min && value <= max);

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// The current value, that is displayed in the subtitle of the list tile,
  /// and used as the currently selected value for the slider.
  final double value;

  /// The minimum value the user can select using the slider.
  ///
  /// Defaults to 0.0. Must be less than or equal to [max].
  ///
  /// If the [max] is equal to the [min], then the slider is disabled.
  final double min;

  /// The maximum value the user can select using the slider.
  ///
  /// Defaults to 1.0. Must be greater than or equal to [min].
  ///
  /// If the [max] is equal to the [min], then the slider is disabled.
  final double max;

  /// The number of discrete divisions of the slider.
  ///
  /// If null, the slider is continuous.
  final int? divisions;

  /// The child widget of the OK button in the Slider dialog.
  ///
  /// Defaults to a Text widget that displays `OK`.
  final Widget okButton;

  /// The child widget of the cancel button in the Slider dialog.
  ///
  /// Defaults to a Text widget that displays `Cancel`.
  final Widget cancelButton;

  /// Called when the user changes the value using the slider and clicks the
  /// OK button.
  final ValueChanged<double>? onChanged;

  /// Called when the value should be displayed in the list tile and in the
  /// Slider dialog. You can use this callback to customize the way the value
  /// is displayed to the user.
  ///
  /// If null, then the [toString] method is used to display the value.
  final String Function(double value)? onDisplayValue;

  Future<void> _onListTileTap(BuildContext context) async {
    double? newValue = await _showSliderDialog(context);
    // Call the onChanged callback only if the value has been changed
    if (newValue != null && newValue != value) {
      onChanged?.call(newValue);
    }
  }

  String _displayValue(double value) =>
      onDisplayValue != null ? onDisplayValue!(value) : value.toString();

  Future<double?> _showSliderDialog(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.bodyText2!.copyWith(
          color: Theme.of(context).textTheme.caption!.color,
        );

    return showDialog<double?>(
      context: context,
      builder: (BuildContext context) {
        double newValue = value;
        return AlertDialog(
          title: title,
          contentPadding: const EdgeInsets.only(bottom: 20.0),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 6.0, 24.0, 20.0),
                    child: Text(_displayValue(newValue), style: valueStyle),
                  ),
                  Slider(
                    value: newValue,
                    min: min,
                    max: max,
                    divisions: divisions,
                    onChanged: (double value) => setState(() => newValue = value),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: cancelButton,
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, newValue),
              child: okButton,
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
      subtitle: Text(_displayValue(value)),
      onTap: () => _onListTileTap(context),
    );
  }
}
