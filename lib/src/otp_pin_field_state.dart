import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_pin_field/otp_pin_field_platform_interface.dart';

import '../otp_pin_field.dart';
import 'gradient_outline_input_border.dart';

class OtpPinFieldState extends State<OtpPinField>
    with TickerProviderStateMixin, OtpPinAutoFill {
  late FocusNode _focusNode;
  late List<String> pinsInputed;
  late AnimationController _cursorController;
  late Animation<double> _cursorAnimation;
  final TextEditingController controller = TextEditingController();
  bool ending = false;
  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    pinsInputed = [];
    if (widget.autoFillEnable == true) {
      if (widget.phoneNumbersHint == true) {
        _OtpPinFieldAutoFill().hint.then((value) {
          widget.onPhoneHintSelected?.call(value);
        });
      }
      _OtpPinFieldAutoFill().getAppSignature.then((value) {
        debugPrint('your hash value is $value');
        _OtpPinFieldAutoFill()
            .listenForCode(smsCodeRegexPattern: widget.smsRegex ?? '\\d{0,4}');
      });
      listenForCode();
    }
    for (var i = 0; i < widget.maxLength; i++) {
      pinsInputed.add('');
    }

    _focusNode.addListener(_focusListener);
    _cursorController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _cursorAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _cursorController,
      curve: Curves.easeIn,
    ));
    _cursorController.repeat();
  }

  @override
  void dispose() {
    if (widget.autoFillEnable == true) {
      cancel();
      _OtpPinFieldAutoFill().unregisterListener();
    }
    _focusNode.removeListener(_focusListener);
    _focusNode.dispose();
    controller.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.showCustomKeyboard ?? false
        ? _viewWithCustomKeyBoard()
        : _viewWithOutCustomKeyBoard();
  }

  Widget _viewWithCustomKeyBoard() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 115,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.upperChild ?? Container(height: 150),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onLongPress: pasteCode,
            onTap: onFieldFocus,
            child: SizedBox(
              height: widget.fieldHeight,
              child: Stack(children: [
                Row(
                    mainAxisAlignment:
                        widget.mainAxisAlignment ?? MainAxisAlignment.center,
                    children: _buildBody(context)),
                AbsorbPointer(
                  child: Opacity(
                    opacity: 0.0,
                    child: TextField(
                      controller: controller,
                      maxLength: widget.maxLength,
                      autofillHints: (widget.autoFillEnable ?? false)
                          ? const [AutofillHints.oneTimeCode]
                          : null,
                      readOnly: widget.showCustomKeyboard ?? true,
                      autofocus: widget.autoFocus,
                      enableInteractiveSelection: false,
                      inputFormatters:
                          widget.keyboardType == TextInputType.number
                              ? <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ]
                              : null,
                      focusNode: _focusNode,
                      keyboardType: widget.keyboardType,
                      onSubmitted: (text) {
                        debugPrint(text);
                      },
                      onChanged: (text) {
                        if (ending && text.length == widget.maxLength) {
                          return;
                        }
                        _bindTextIntoWidget(text);
                        setState(() {});
                        widget.onChange(text);
                        ending = text.length == widget.maxLength;
                        if (ending) {
                          widget.onSubmit(text);
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                  ),
                )
              ]),
            ),
          ),
          Expanded(child: widget.middleChild ?? const SizedBox.shrink()),
          Align(
              alignment: Alignment.bottomCenter,
              child: widget.customKeyboard ??
                  OtpKeyboard(
                    callbackValue: (myText) {
                      if (ending &&
                          controller.text.trim().length == widget.maxLength) {
                        return;
                      }
                      controller.text = controller.text + myText;
                      _bindTextIntoWidget(controller.text.trim());
                      setState(() {});
                      widget.onChange(controller.text.trim());
                      ending =
                          controller.text.trim().length == widget.maxLength;
                      if (ending) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                    callbackDeleteValue: () {
                      if (controller.text.isEmpty) {
                        return;
                      }
                      _focusNode.requestFocus();
                      controller.text = controller.text
                          .substring(0, controller.text.length - 1);
                      _bindTextIntoWidget(controller.text.trim());
                      setState(() {});
                      widget.onChange(controller.text.trim());
                    },
                    callbackSubmitValue: () {
                      if (controller.text.length != widget.maxLength) {
                        return;
                      }
                      widget.onSubmit(controller.text);
                    },
                  ))
        ],
      ),
    );
  }

  Widget _viewWithOutCustomKeyBoard() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: pasteCode,
      onTap: onFieldFocus,
      child: SizedBox(
        height: widget.fieldHeight,
        child: Stack(children: [
          Row(
              mainAxisAlignment:
                  widget.mainAxisAlignment ?? MainAxisAlignment.center,
              children: _buildBody(context)),
          AbsorbPointer(
            absorbing: true,
            child: Opacity(
              opacity: 0.0,
              child: TextField(
                controller: controller,
                maxLength: widget.maxLength,
                autofillHints: (widget.autoFillEnable ?? false)
                    ? const [AutofillHints.oneTimeCode]
                    : null,
                readOnly: !(widget.showDefaultKeyboard ?? true),
                autofocus: widget.autoFocus,
                enableInteractiveSelection: false,
                inputFormatters: widget.keyboardType == TextInputType.number
                    ? <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ]
                    : null,
                focusNode: _focusNode,
                textInputAction: widget.textInputAction,
                keyboardType: widget.keyboardType,
                onSubmitted: (text) {
                  debugPrint(text);
                },
                onChanged: (text) {
                  if (ending && text.length == widget.maxLength) {
                    return;
                  }
                  _bindTextIntoWidget(text);
                  setState(() {});
                  widget.onChange(text);
                  ending = text.length == widget.maxLength;
                  if (ending) {
                    widget.onSubmit(text);
                    FocusScope.of(context).unfocus();
                  }
                },
              ),
            ),
          )
        ]),
      ),
    );
  }

  void onFieldFocus() {
    if (kIsWeb) {
      _focusNode.requestFocus();
      return;
    }
    if (View.of(context).viewInsets.bottom <= 0.0 &&
        controller.text.trim().length != widget.maxLength) {
      FocusScope.of(context).unfocus();
      _focusNode = FocusNode();
      _focusNode.addListener(_focusListener);
    }
    _focusNode.requestFocus();
    setState(() {});
  }

  List<Widget> _buildBody(BuildContext context) {
    var tmp = <Widget>[];
    for (var i = 0; i < widget.maxLength; i++) {
      tmp.add(_buildFieldInput(context, i));
      if (i < widget.maxLength - 1) {
        tmp.add(SizedBox(
          width: widget.otpPinFieldStyle!.fieldPadding,
        ));
      }
    }
    return tmp;
  }

  Widget cursorWidget({Color? cursorColor, double? cursorWidth, int? index}) {
    return Container(
      padding: pinsInputed[index ?? 0].isNotEmpty
          ? const EdgeInsets.only(left: 15)
          : EdgeInsets.zero,
      child: FadeTransition(
        opacity: _cursorAnimation,
        child: CustomPaint(
          size: const Size(0, 25),
          painter: CursorPainter(
            cursorColor: cursorColor,
            cursorWidth: cursorWidth,
          ),
        ),
      ),
    );
  }

  Widget _buildFieldInput(BuildContext context, int i) {
    Color fieldBorderColor;
    Color? fieldBackgroundColor;
    Gradient fieldBorderGradient;
    BoxDecoration foregroundBoxDecoration;
    List<BoxShadow>? boxShadow;

    Widget showCursorWidget() => widget.showCursor!
        ? _shouldHighlight(i)
            ? cursorWidget(
                cursorColor: widget.cursorColor,
                cursorWidth: widget.cursorWidth,
                index: i)
            : const SizedBox.shrink()
        : const SizedBox.shrink();

    fieldBorderColor = widget.highlightBorder && _shouldHighlight(i)
        ? widget.otpPinFieldStyle!.activeFieldBorderColor
        : (pinsInputed[i].isNotEmpty &&
                widget.otpPinFieldStyle?.filledFieldBorderColor !=
                    Colors.transparent)
            ? widget.otpPinFieldStyle!.filledFieldBorderColor
            : widget.otpPinFieldStyle!.defaultFieldBorderColor;

    boxShadow = widget.highlightBorder && _shouldHighlight(i)
        ? widget.otpPinFieldStyle!.activeFieldBoxShadow
        : (pinsInputed[i].isNotEmpty &&
                widget.otpPinFieldStyle?.filledFieldBoxShadow != null)
            ? widget.otpPinFieldStyle!.filledFieldBoxShadow
            : widget.otpPinFieldStyle!.defaultFieldBoxShadow;
    fieldBackgroundColor = widget.highlightBorder && _shouldHighlight(i)
        ? widget.otpPinFieldStyle!.activeFieldBackgroundColor
        : (pinsInputed[i].isNotEmpty &&
                widget.otpPinFieldStyle?.filledFieldBackgroundColor !=
                    Colors.transparent)
            ? widget.otpPinFieldStyle!.filledFieldBackgroundColor
            : widget.otpPinFieldStyle!.defaultFieldBackgroundColor;

    fieldBorderGradient = (widget.otpPinFieldDecoration ==
                OtpPinFieldDecoration.underlinedPinBoxDecoration
            ? null
            : widget.highlightBorder &&
                    _shouldHighlight(i) &&
                    widget.otpPinFieldStyle?.activeFieldBorderGradient != null
                ? widget.otpPinFieldStyle!.activeFieldBorderGradient
                : (pinsInputed[i].isNotEmpty &&
                        widget.otpPinFieldStyle?.filledFieldBorderGradient !=
                            null)
                    ? widget.otpPinFieldStyle!.filledFieldBorderGradient
                    : widget.otpPinFieldStyle?.defaultFieldBorderGradient) ??
        LinearGradient(colors: [fieldBorderColor, fieldBorderColor]);

    if (widget.otpPinFieldDecoration ==
        OtpPinFieldDecoration.underlinedPinBoxDecoration) {
      foregroundBoxDecoration = BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: fieldBorderColor,
            width: widget.otpPinFieldStyle!.fieldBorderWidth,
          ),
        ),
      );
    } else if (widget.otpPinFieldDecoration ==
        OtpPinFieldDecoration.defaultPinBoxDecoration) {
      foregroundBoxDecoration = BoxDecoration(
          boxShadow: boxShadow,
          color: fieldBackgroundColor,
          border: GradientBoxBorder(
            gradient: fieldBorderGradient,
            width: widget.otpPinFieldStyle!.fieldBorderWidth,
          ),
          borderRadius: BorderRadius.circular(5.0));
    } else if (widget.otpPinFieldDecoration ==
        OtpPinFieldDecoration.roundedPinBoxDecoration) {
      foregroundBoxDecoration = BoxDecoration(
        boxShadow: boxShadow,
        color: fieldBackgroundColor,
        border: GradientBoxBorder(
          gradient: fieldBorderGradient,
          width: widget.otpPinFieldStyle!.fieldBorderWidth,
        ),
        shape: BoxShape.circle,
      );
    } else {
      foregroundBoxDecoration = BoxDecoration(
          boxShadow: boxShadow,
          color: fieldBackgroundColor,
          border: GradientBoxBorder(
            gradient: fieldBorderGradient,
            width: widget.otpPinFieldStyle!.fieldBorderWidth,
          ),
          borderRadius: BorderRadius.circular(
              widget.otpPinFieldStyle!.fieldBorderRadius));
    }

    return Container(
        width: widget.fieldWidth,
        alignment: Alignment.center,
        decoration: foregroundBoxDecoration,
        child: Stack(
          children: [
            Center(
              child: showCursorWidget(),
            ),
            Center(
              child: Text(
                _getPinDisplay(i),
                style: pinsInputed[i].isEmpty &&
                        widget.otpPinFieldStyle?.showHintText == true
                    ? widget.otpPinFieldStyle?.textStyle
                        .copyWith(color: widget.otpPinFieldStyle?.hintTextColor)
                    : widget.otpPinFieldStyle?.textStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ));
  }

  String _getPinDisplay(int position) {
    var display = '';
    var value = pinsInputed[position];
    switch (widget.otpPinFieldInputType) {
      case OtpPinFieldInputType.password:
        display = '*';
        break;
      case OtpPinFieldInputType.custom:
        display = widget.otpPinInputCustom;
        break;
      default:
        display = value;
        break;
    }

    if (value.isEmpty && widget.otpPinFieldStyle?.showHintText == true) {
      return widget.otpPinFieldStyle?.hintText ?? '0';
    }

    return value.isNotEmpty ? display : value;
  }

  void _bindTextIntoWidget(String text) {
    for (var i = text.length; i < pinsInputed.length; i++) {
      pinsInputed[i] = '';
    }
    if (text.isNotEmpty) {
      for (var i = 0; i < text.length; i++) {
        pinsInputed[i] = text[i];
      }
    }
  }

  void _focusListener() {
    if (mounted == true) {
      setState(() {
        hasFocus = _focusNode.hasFocus;
      });
    }
  }

  bool _shouldHighlight(int i) {
    return hasFocus &&
        (i == controller.text.trim().length ||
            (i == controller.text.trim().length - 1 &&
                controller.text.trim().length == widget.maxLength));
  }

  clearOtp() {
    controller.text = '';
    setState(() {
      _focusNode = FocusNode();
      pinsInputed = [];
      for (var i = 0; i < widget.maxLength; i++) {
        pinsInputed.add('');
      }
      _focusNode.addListener(_focusListener);
      ending = false;
      hasFocus = widget.highlightBorder;
    });
  }

  @override
  void codeUpdated() {
    debugPrint('auto fill sms code is $code');
    if (controller.text != code && code != null) {
      controller.value = TextEditingValue(text: code ?? '');
      if (widget.onCodeChanged != null) {
        widget.onCodeChanged!(code ?? '');
      }
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {
        _focusNode = FocusNode();
        if (code?.isNotEmpty == true) {
          for (var i = 0; i < code!.length; i++) {
            pinsInputed[i] = code![i];
          }
        }
        _focusNode.addListener(_focusListener);
        ending = true;
        hasFocus = widget.highlightBorder;
        controller.text = code!;
      });
    }
  }

  void _pasteCopyCode(ClipboardData? data) {
    try {
      int.parse(data?.text ?? '');
    } catch (e) {
      return log(
          name: 'OTP Pin Field',
          'Copied content error ',
          error: 'The content that is copied should be a number.');
    }

    if ((data?.text ?? '').length < widget.maxLength) {
      return log(
          name: 'OTP Pin Field',
          'Copied content error',
          error: "The copied content doesn't seem to be the correct OTP.");
    }

    if (controller.text != data?.text && (data?.text ?? '').isNotEmpty) {
      if ((data?.text ?? '').length < widget.maxLength) {
        return log(
            name: 'OTP Pin Field',
            'Copied content error',
            error: "The copied content doesn't seem to be the correct OTP.");
      }

      controller.value = TextEditingValue(
          text: (data?.text ?? '').substring(0, widget.maxLength));

      if ((data?.text ?? '').substring(0, widget.maxLength).isNotEmpty ==
          true) {
        for (var i = 0; i < widget.maxLength; i++) {
          pinsInputed[i] = (data?.text ?? '')[i];
        }
      }
      controller.text = (data?.text ?? '').substring(0, widget.maxLength);
      setState(() {});

      widget.onChange(controller.text.trim());
      ending = controller.text.trim().length == widget.maxLength;
      if (ending) {
        widget.onSubmit(controller.text.trim());
        FocusScope.of(context).unfocus();
        _hideKeyboard();
      }
    }
  }

  void pasteCode() async {
    var data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text?.isNotEmpty ?? false) {
      if (widget.beforeTextPaste != null) {
        if (widget.beforeTextPaste?.call(data!.text) ?? false) {
          _pasteCopyCode(data);
        } else {
          log(
              name: 'OTP Pin Field',
              'beforeTextPaste error ',
              error:
                  'return true in beforeTextPaste order to execute copy paste ');
        }
      } else {
        _pasteCopyCode(data);
      }
    }
  }
}

class _OtpPinFieldAutoFill {
  static _OtpPinFieldAutoFill? _singleton;
  static const MethodChannel _channel = MethodChannel('otp_pin_field');
  final StreamController<String> _code = StreamController.broadcast();

  factory _OtpPinFieldAutoFill() => _singleton ??= _OtpPinFieldAutoFill._();

  _OtpPinFieldAutoFill._() {
    _channel.setMethodCallHandler(_didReceive);
  }

  Future<String?> getPlatformVersion() {
    return OtpPinFieldPlatform.instance.getPlatformVersion();
  }

  Future<void> _didReceive(MethodCall method) async {
    if (method.method == 'smsCode') {
      _code.add(method.arguments);
    }
  }

  Stream<String> get code => _code.stream;

  Future<String?> get hint async {
    return OtpPinFieldPlatform.instance.requestPhoneHint();
  }

  Future<void> listenForCode({String smsCodeRegexPattern = '\\d{0,4}'}) async {
    OtpPinFieldPlatform.instance.listenForCode(
        <String, String>{'smsCodeRegexPattern': smsCodeRegexPattern});
  }

  Future<void> unregisterListener() async {
    OtpPinFieldPlatform.instance.unregisterListener();
  }

  Future<String> get getAppSignature async {
    return OtpPinFieldPlatform.instance.getAppSignature();
  }
}

mixin OtpPinAutoFill {
  final _OtpPinFieldAutoFill _autoFill = _OtpPinFieldAutoFill();
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

void _hideKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}
