import 'package:example_otp_pin_field/next_page.dart';
import 'package:flutter/material.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OtpPinField(
              onSubmit: (text) {
                print('Entered pin is $text'); // return the entered pin
              },
              // to decorate your Otp_Pin_Field
              otpPinFieldStyle: OtpPinFieldStyle(
                // border color for inactive/unfocused Otp_Pin_Field
                defaultFieldBorderColor: Colors.red,
                // border color for active/focused Otp_Pin_Field
                activeFieldBorderColor: Colors.indigo,
                // Background Color for inactive/unfocused Otp_Pin_Field
                defaultFieldBackgroundColor: Colors.yellow,
                activeFieldBackgroundColor: Colors
                    .cyanAccent, // Background Color for active/focused Otp_Pin_Field
              ),
              maxLength: 6,
              // no of pin field
              // predefine decorate of pinField use  OtpPinFieldDecoration.defaultPinBoxDecoration||OtpPinFieldDecoration.underlinedPinBoxDecoration||OtpPinFieldDecoration.roundedPinBoxDecoration
              //use OtpPinFieldDecoration.custom  (by using this you can make Otp_Pin_Field according to yourself like you can give fieldBorderRadius,fieldBorderWidth and etc things)
              otpPinFieldDecoration:
                  OtpPinFieldDecoration.defaultPinBoxDecoration,
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NextPage())),
                child: Text("Next Class"))
          ],
        ),
      ),
    );
  }
}
