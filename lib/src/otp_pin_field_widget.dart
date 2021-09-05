import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:otp_pin_field/src/otp_pin_field_state.dart';

import '../src/otp_pin_field_style.dart';

typedef OnDone = void Function(String text);

class OtpPinField extends StatefulWidget {
  final double fieldHeight;
  final double fieldWidth;
  final int maxLength;
  final OtpPinFieldStyle? otpPinFieldStyle;
  final OnDone onSubmit;
  final OtpPinFieldInputType otpPinFieldInputType;
  final String otpPinInputCustom;
  final OtpPinFieldDecoration otpPinFieldDecoration;
  final TextInputType keyboardType;
  final bool autoFocus;
  final bool highlightBorder;

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
    this.keyboardType = TextInputType.number,
    this.autoFocus = true,
    this.highlightBorder = true,
  });

  @override
  State<StatefulWidget> createState() {
    return OtpPinFieldState();
  }
}
