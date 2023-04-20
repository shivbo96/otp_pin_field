library otp_pin_field;

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:otp_pin_field/otp_pin_field_platform_interface.dart';
export '../src/otp_pin_field_widget.dart';
export '../src/otp_pin_field_style.dart';
export '../src/otp_pin_field_input_type.dart';
export '../src/custom_keyboard.dart';
export '../src/cursor_painter.dart';
export '../src/otp_pin_field_state.dart';

class OtpPinFieldAutoFill {
  static OtpPinFieldAutoFill? _singleton;
  static const MethodChannel _channel = MethodChannel('otp_pin_field');
  final StreamController<String> _code = StreamController.broadcast();

  factory OtpPinFieldAutoFill() => _singleton ??= OtpPinFieldAutoFill._();

  OtpPinFieldAutoFill._() {
    _channel.setMethodCallHandler(_didReceive);
  }

  Future<String?> getPlatformVersion() {
    return OtpPinFieldPlatform.instance.getPlatformVersion();
  }

  Future<void> _didReceive(MethodCall method) async {
    if (method.method == 'smscode') {
      _code.add(method.arguments);
    }
  }

  Stream<String> get code => _code.stream;

  Future<String?> get hint async {
    final String? hint = await _channel.invokeMethod('requestPhoneHint');
    return hint;
  }

  Future<void> listenForCode({String smsCodeRegexPattern = '\\d{0,4}'}) async {
    await _channel.invokeMethod('listenForCode', <String, String>{'smsCodeRegexPattern': smsCodeRegexPattern});
  }

  Future<void> unregisterListener() async {
    await _channel.invokeMethod('unregisterListener');
  }

  Future<String> get getAppSignature async {
    final String? appSignature = await _channel.invokeMethod('getAppSignature');
    return appSignature ?? '';
  }
}

mixin CodeAutoFill {
  final OtpPinFieldAutoFill _autoFill = OtpPinFieldAutoFill();
  String? code;
  StreamSubscription? _subscription;

  void listenForCode({String? smsCodeRegexPattern}) {
    _subscription = _autoFill.code.listen((code) {
      this.code = code;
      codeUpdated();
    });


    (smsCodeRegexPattern == null)
        ? _autoFill.listenForCode()
        : _autoFill.listenForCode(smsCodeRegexPattern: smsCodeRegexPattern);
  }

  Future<void> cancel() async {
    return _subscription?.cancel();
  }

  Future<void> unregisterListener() {
    return _autoFill.unregisterListener();
  }

  void codeUpdated();
}
