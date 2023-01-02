import 'package:flutter/material.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:otp_pin_field/src/otp_pin_field_state.dart';

typedef OnDone = void Function(String text);
typedef OnChange = void Function(String text);

class OtpPinField extends StatefulWidget {
  final double fieldHeight;
  final double fieldWidth;
  final int maxLength;
  final OtpPinFieldStyle? otpPinFieldStyle;
  final OnDone onSubmit;
  final OnChange onChange;
  final OtpPinFieldInputType otpPinFieldInputType;
  final String otpPinInputCustom;
  final OtpPinFieldDecoration otpPinFieldDecoration;
  final TextInputType keyboardType;
  final bool autoFocus;
  final bool highlightBorder;
  final Color? cursorColor;
  final double? cursorWidth;
  final bool? showCursor;
  final MainAxisAlignment? mainAxisAlignment;
  final Widget? upperChild;
  final Widget? middleChild;
  final Widget? customKeyboard;
  final bool? showCustomKeyboard;
  final bool? showDefaultKeyboard;

  OtpPinField({
    this.fieldHeight = 50.0,
    this.fieldWidth = 50.0,
    this.maxLength = 4,
    this.otpPinFieldStyle = const OtpPinFieldStyle(),
    this.otpPinFieldInputType = OtpPinFieldInputType.none,
    this.otpPinFieldDecoration =
        OtpPinFieldDecoration.underlinedPinBoxDecoration,
    this.otpPinInputCustom = "*",
    required this.onSubmit,
    required this.onChange,
    this.keyboardType = TextInputType.number,
    this.autoFocus = true,
    this.highlightBorder = true,
    this.showCursor = true,
    this.cursorColor,
    this.cursorWidth=2,
    this.mainAxisAlignment,
    this.upperChild,
    this.middleChild,
    this.customKeyboard,
    this.showCustomKeyboard,
    this.showDefaultKeyboard=true
  });

  @override
  State<StatefulWidget> createState() {
    return OtpPinFieldState();
  }
}
