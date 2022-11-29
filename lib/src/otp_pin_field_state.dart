import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_pin_field/src/cursor_painter.dart';
import 'package:otp_pin_field/src/custom_keyboard.dart';

import '../otp_pin_field.dart';

class OtpPinFieldState extends State<OtpPinField>
    with TickerProviderStateMixin {
  late FocusNode _focusNode;
  late List<String> pinsInputed;
  late AnimationController _cursorController;
  late Animation<double> _cursorAnimation;
  final TextEditingController controller = TextEditingController();
  bool ending = false;
  bool hasFocus = false;
  String text = "";

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    pinsInputed = [];
    for (var i = 0; i < widget.maxLength; i++) {
      pinsInputed.add("");
    }
    _focusNode.addListener(_focusListener);
    _cursorController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _cursorController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
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
    // Clean up the focus node when the Form is disposed.
    _focusNode.removeListener(_focusListener);
    _focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.showCustomKeyboard??false?_viewWithCustomKeyBoard():_viewWithOutCustomKeyBoard();
  }


  Widget _viewWithCustomKeyBoard(){
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.upperChild ?? Container(height: 150),
          Container(
            height: widget.fieldHeight,
            child: Stack(children: [
              Row(
                  mainAxisAlignment:
                  widget.mainAxisAlignment ?? MainAxisAlignment.center,
                  children: _buildBody(context)),
              Opacity(
                child: TextField(
                  controller: controller,
                  maxLength: widget.maxLength,
                  readOnly: widget.showCustomKeyboard??false,
                  autofocus: !kIsWeb ? widget.autoFocus : false,
                  enableInteractiveSelection: false,
                  inputFormatters: widget.keyboardType == TextInputType.number
                      ? <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ]
                      : null,
                  focusNode: _focusNode,
                  keyboardType: widget.keyboardType,
                  onSubmitted: (text) {
                    print(text);
                  },
                  onChanged: (text) {
                    this.text = text;
                    // FocusScope.of(context).nextFocus();
                    if (ending && text.length == widget.maxLength) {
                      return;
                    }
                    _bindTextIntoWidget(text);
                    setState(() {});
                    widget.onChange!(text);
                    ending = text.length == widget.maxLength;
                    if (ending) {
                      widget.onSubmit(text);
                      FocusScope.of(context).unfocus();
                    }
                  },
                ),
                opacity: 0.0,
              )
            ]),
          ),
          Expanded(child: widget.middleChild ?? Container()),
          Align(
              alignment: Alignment.bottomCenter,
              child: OtpKeyboard(
                callbackValue: (myText) {
                  // FocusScope.of(context).nextFocus();
                  if (ending && text.length == widget.maxLength) {
                    return;
                  }
                  controller.text = controller.text + myText;
                  this.text = controller.text;
                  _bindTextIntoWidget(text);
                  setState(() {});
                  widget.onChange!(text);
                  ending = text.length == widget.maxLength;
                  if (ending) {
                    widget.onSubmit(text);
                    FocusScope.of(context).unfocus();
                  }
                },
                callbackDeleteValue: () {
                  if (controller.text.isEmpty) {
                    return;
                  }
                  _focusNode.requestFocus();
                  controller.text =
                      controller.text.substring(0, controller.text.length - 1);
                  this.text = controller.text;
                  _bindTextIntoWidget(text);
                  setState(() {});
                  widget.onChange!(text);
                },
              ))
        ],
      ),
    );
  }
  Widget _viewWithOutCustomKeyBoard(){
    return Container(
      height: widget.fieldHeight,
      child: Stack(children: [
        Row(
            mainAxisAlignment:
            widget.mainAxisAlignment ?? MainAxisAlignment.center,
            children: _buildBody(context)),
        Opacity(
          child: TextField(
            controller: controller,
            maxLength: widget.maxLength,
            readOnly: widget.showCustomKeyboard??false,
            autofocus: !kIsWeb ? widget.autoFocus : false,
            enableInteractiveSelection: false,
            inputFormatters: widget.keyboardType == TextInputType.number
                ? <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ]
                : null,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            onSubmitted: (text) {
              print(text);
            },
            onChanged: (text) {
              this.text = text;
              // FocusScope.of(context).nextFocus();
              if (ending && text.length == widget.maxLength) {
                return;
              }
              _bindTextIntoWidget(text);
              setState(() {});
              widget.onChange!(text);
              ending = text.length == widget.maxLength;
              if (ending) {
                widget.onSubmit(text);
                FocusScope.of(context).unfocus();
              }
            },
          ),
          opacity: 0.0,
        )
      ]),
    );
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

  Widget cursorWidget({Color? cursorColor, double? cursorWidth}) {
    return Center(
      child: FadeTransition(
        opacity: _cursorAnimation,
        child: CustomPaint(
          size: Size(0, 25),
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
    BoxDecoration boxDecoration;

    Widget showCursorWidget() => widget.showCursor!
        ? _shouldHighlight(i)
            ? cursorWidget(
                cursorColor: widget.cursorColor,
                cursorWidth: widget.cursorWidth)
            : Container()
        : Container();

    fieldBorderColor = widget.highlightBorder && _shouldHighlight(i)
        ? widget.otpPinFieldStyle!.activeFieldBorderColor
        : widget.otpPinFieldStyle!.defaultFieldBorderColor;
    fieldBackgroundColor = widget.highlightBorder && _shouldHighlight(i)
        ? widget.otpPinFieldStyle!.activeFieldBackgroundColor
        : widget.otpPinFieldStyle!.defaultFieldBackgroundColor;

    if (widget.otpPinFieldDecoration ==
        OtpPinFieldDecoration.underlinedPinBoxDecoration) {
      boxDecoration = BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: fieldBorderColor,
            width: 2.0,
          ),
        ),
      );
    } else if (widget.otpPinFieldDecoration ==
        OtpPinFieldDecoration.defaultPinBoxDecoration) {
      boxDecoration = BoxDecoration(
          border: Border.all(color: fieldBorderColor, width: 2.0),
          color: fieldBackgroundColor,
          borderRadius: BorderRadius.circular(5.0));
    } else if (widget.otpPinFieldDecoration ==
        OtpPinFieldDecoration.roundedPinBoxDecoration) {
      boxDecoration = BoxDecoration(
        border: Border.all(
          color: fieldBorderColor,
          width: widget.otpPinFieldStyle!.fieldBorderWidth,
        ),
        shape: BoxShape.circle,
        color: fieldBackgroundColor,
      );
    } else {
      boxDecoration = BoxDecoration(
          border: Border.all(
            color: fieldBorderColor,
            width: 2.0,
          ),
          color: fieldBackgroundColor,
          borderRadius: BorderRadius.circular(
              widget.otpPinFieldStyle!.fieldBorderRadius));
    }

    return InkWell(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: Container(
          width: widget.fieldWidth,
          alignment: Alignment.center,
          child: Stack(
            children: [
              showCursorWidget(),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Text(
                    _getPinDisplay(i),
                    style: widget.otpPinFieldStyle!.textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          decoration: boxDecoration),
    );
  }

  String _getPinDisplay(int position) {
    var display = "";
    var value = pinsInputed[position];
    switch (widget.otpPinFieldInputType) {
      case OtpPinFieldInputType.password:
        display = "*";
        break;
      case OtpPinFieldInputType.custom:
        display = widget.otpPinInputCustom;
        break;
      default:
        display = value;
        break;
    }
    return value.isNotEmpty ? display : value;
  }

  void _bindTextIntoWidget(String text) {
    ///Reset value
    for (var i = text.length; i < pinsInputed.length; i++) {
      pinsInputed[i] = "";
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
        (i == text.length ||
            (i == text.length - 1 && text.length == widget.maxLength));
  }
}
