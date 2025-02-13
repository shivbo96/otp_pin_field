import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

import 'next_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

void _hideKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

class _MyHomePageState extends State<MyHomePage> {
  ///  Otp pin Controller
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _hideKeyboard(),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OtpPinField(
              key: _otpPinFieldController,

              ///in case you want to enable autoFill
              autoFillEnable: true,

              ///for Ios it is not needed as the SMS autofill is provided by default, but not for Android, that's where this key is useful.
              textInputAction: TextInputAction.done,

              ///in case you want to change the action of keyboard
              /// to clear the Otp pin Controller
              onSubmit: (text) {
                debugPrint('Entered pin is $text');

                /// return the entered pin
              },
              onChange: (text) {
                debugPrint('Enter on change pin is $text');

                /// return the entered pin
              },
              onCodeChanged: (code) {
                debugPrint('onCodeChanged  is $code');
              },

              /// to decorate your Otp_Pin_Field
              otpPinFieldStyle: const OtpPinFieldStyle(
                /// bool to show hints in pin field or not
                showHintText: true,

                /// to set the color of hints in pin field or not
                // hintTextColor: Colors.red,

                /// to set the text  of hints in pin field
                // hintText: '1',

                /// border color for inactive/unfocused Otp_Pin_Field
                // defaultFieldBorderColor: Colors.red,

                /// border color for active/focused Otp_Pin_Field
                // activeFieldBorderColor: Colors.indigo,

                /// Background Color for inactive/unfocused Otp_Pin_Field
                // defaultFieldBackgroundColor: Colors.yellow,

                /// Background Color for active/focused Otp_Pin_Field
                // activeFieldBackgroundColor: Colors.cyanAccent,

                /// Background Color for filled field pin box
                // filledFieldBackgroundColor: Colors.green,

                /// border Color for filled field pin box
                // filledFieldBorderColor: Colors.green,
                //
                /// gradient border Color for field pin box
                activeFieldBorderGradient: LinearGradient(
                  colors: [Colors.black, Colors.redAccent],
                ),
                filledFieldBorderGradient: LinearGradient(
                  colors: [Colors.green, Colors.tealAccent],
                ),
                defaultFieldBorderGradient: LinearGradient(
                  colors: [Colors.orange, Colors.brown],
                ),
                fieldBorderWidth: 3,
              ),
              maxLength: 4,

              /// no of pin field
              showCursor: true,

              /// bool to show cursor in pin field or not
              cursorColor: Colors.indigo,

              /// to choose cursor color
              upperChild: const Column(
                children: [
                  SizedBox(height: 30),
                  Icon(Icons.flutter_dash_outlined, size: 150),
                  SizedBox(height: 20),
                ],
              ),
              // 123456
              middleChild: Column(
                children: [
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      _otpPinFieldController.currentState
                          ?.clearOtp(); // clear controller
                    },
                    child: const Text('clear OTP'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NextPage(),
                          ),
                        ),
                    child: const Text('Next Class'),
                  ),
                  const SizedBox(height: 30),
                ],
              ),

              ///bool which manage to show custom keyboard
              // showCustomKeyboard: true,

              /// Widget which help you to show your own custom keyboard in place if default custom keyboard
              // customKeyboard: Container(),
              ///bool which manage to show default OS keyboard
              // showDefaultKeyboard: true,

              /// to select cursor width
              cursorWidth: 3,

              /// place otp pin field according to yourself
              mainAxisAlignment: MainAxisAlignment.center,

              /// predefine decorate of pinField use  OtpPinFieldDecoration.defaultPinBoxDecoration||OtpPinFieldDecoration.underlinedPinBoxDecoration||OtpPinFieldDecoration.roundedPinBoxDecoration
              ///use OtpPinFieldDecoration.custom  (by using this you can make Otp_Pin_Field according to yourself like you can give fieldBorderRadius,fieldBorderWidth and etc things)
              otpPinFieldDecoration:
                  OtpPinFieldDecoration.defaultPinBoxDecoration,
            ),
          ],
        ),
      ),
    );
  }
}
