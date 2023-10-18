import 'package:flutter/material.dart';

extension AppThemeExtension on BuildContext {
  double get fullHeight => MediaQuery.sizeOf(this).height;
  double get fullWidth => MediaQuery.sizeOf(this).width;

  Color get backgroundColor => Theme.of(this).primaryColor;
  Color? get backgroundColorMessageReceiver =>
      Theme.of(this).brightness == Brightness.light
          ? Colors.grey[400]
          : Colors.grey[700];

  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;
  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;
  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;
  TextStyle? get titleExtraSmall =>
      Theme.of(this).textTheme.titleSmall?.copyWith(fontSize: 14);
}
