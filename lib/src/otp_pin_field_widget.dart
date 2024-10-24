import 'package:flutter/material.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

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
  final TextInputAction textInputAction;
  final bool autoFocus;
  final bool? autoFillEnable;
  final bool? phoneNumbersHint;
  final String? smsRegex;
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
  final Function(String)? onCodeChanged;
  final bool Function(String? text)? beforeTextPaste;
  final Function(String?)? onPhoneHintSelected;

  const OtpPinField({
    super.key,
    this.fieldHeight = 50.0,
    this.fieldWidth = 50.0,
    this.maxLength = 4,
    this.onCodeChanged,
    this.otpPinFieldStyle = const OtpPinFieldStyle(),
    this.textInputAction = TextInputAction.done,
    this.otpPinFieldInputType = OtpPinFieldInputType.none,
    this.otpPinFieldDecoration =
        OtpPinFieldDecoration.underlinedPinBoxDecoration,
    this.otpPinInputCustom = '*',
    this.smsRegex,
    this.beforeTextPaste,
    required this.onSubmit,
    required this.onChange,
    this.keyboardType = TextInputType.number,
    this.autoFocus = true,
    this.autoFillEnable = false,
    this.phoneNumbersHint = false,
    this.highlightBorder = true,
    this.showCursor = true,
    this.cursorColor,
    this.cursorWidth = 2,
    this.mainAxisAlignment,
    this.upperChild,
    this.middleChild,
    this.customKeyboard,
    this.showCustomKeyboard,
    this.onPhoneHintSelected,
    this.showDefaultKeyboard = true,
  });

  @override
  State<StatefulWidget> createState() {
    return OtpPinFieldState();
  }
}
