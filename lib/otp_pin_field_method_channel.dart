import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'otp_pin_field_platform_interface.dart';

/// An implementation of [OtpPinFieldPlatform] that uses method channels.
class MethodChannelOtpPinField extends OtpPinFieldPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('otp_pin_field');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
