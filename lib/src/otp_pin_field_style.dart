import 'package:flutter/material.dart';

class OtpPinFieldStyle {
  final TextStyle textStyle;
  final bool showHintText;
  final String hintText;
  final Color hintTextColor;
  final double fieldPadding;
  final Color activeFieldBackgroundColor;
  final Color defaultFieldBackgroundColor;
  final Color activeFieldBorderColor;
  final Color defaultFieldBorderColor;
  final Color filledFieldBackgroundColor;
  final Color filledFieldBorderColor;
  final double fieldBorderRadius;
  final double fieldBorderWidth;
  final Gradient? activeFieldBorderGradient;
  final Gradient? filledFieldBorderGradient;
  final Gradient? defaultFieldBorderGradient;
  final List<BoxShadow>? activeFieldBoxShadow;
  final List<BoxShadow>? filledFieldBoxShadow;
  final List<BoxShadow>? defaultFieldBoxShadow;

  const OtpPinFieldStyle({
    this.textStyle = const TextStyle(fontSize: 22.0, color: Colors.black),
    this.showHintText = false,
    this.hintText = '0',
    this.hintTextColor = Colors.black45,
    this.activeFieldBorderColor = Colors.black,
    this.defaultFieldBorderColor = Colors.black45,
    this.activeFieldBackgroundColor = Colors.transparent,
    this.defaultFieldBackgroundColor = Colors.transparent,
    this.filledFieldBackgroundColor = Colors.transparent,
    this.filledFieldBorderColor = Colors.transparent,
    this.activeFieldBorderGradient,
    this.filledFieldBorderGradient,
    this.defaultFieldBorderGradient,
    this.fieldPadding = 10.0,
    this.fieldBorderRadius = 2.0,
    this.fieldBorderWidth = 2.0,
    this.activeFieldBoxShadow,
    this.filledFieldBoxShadow,
    this.defaultFieldBoxShadow,
  });
}
