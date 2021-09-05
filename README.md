[![Pub](https://img.shields.io/pub/v/otp_pin_field.svg)](https://pub.dartlang.org/packages/otp_pin_field)

# otp_pin_field

A flutter package which will help you to generate pin code fields with beautiful design and
animations. It's a beautiful and highly customizable Flutter widget for entering pin code. Can be
useful for OTP or pin code inputs.

# Usage

## Use this package as a library

1. Depend on it Add this to your package's pubspec.yaml file:

```
dependencies:
  otp_pin_field: <VERSION>
```

2. Install it You can install packages from the command line:
   with Flutter:

```
$ flutter pub add otp_pin_field
```

Alternatively, your editor might support flutter packages get. Check the docs for your editor to
learn more.

3. Import it Now in your Dart code, you can use:

```
import 'package:otp_pin_field/otp_pin.dart';
```

## Properties
| name | type | default | description |
| --- | --- | --- | --- |
| fieldCount | int | 4 | The total length of pin number & the number of pin boxes. |
| highlightBorder | bool | true | highlight the focused pin box. |
| activeFieldBorderColor | Color | Colors.black | Set color of the focused pin box. |
| activeFieldBackgroundColor | Color | Colors.transparent | Set background color of the focused pin box. |
| defaultFieldBorderColor | Color | Colors.black45 | Set color of the unfocused pin box. |
| defaultFieldBackgroundColor | Color | Colors.transparent | Set background color of the unfocused pin box. |
| fieldPadding | double | 20.0 | Set padding for pin box. |
| fieldBorderRadius | double | 2.0 | Set border radius for pin box. |
| fieldBorderWidth | double | 2.0 | Set border width for pin box. |
| textStyle | TextStyle | TextStyle(fontSize: 18.0,color: Colors.black,) | TextStyle for styling pin characters. |
| otpPinFieldInputType | OtpPinFieldInputType | OtpPinFieldInputType.none | Want to show text of otp_pin_field`(OtpPinFieldInputType.none)` or not`(OtpPinFieldInputType.password)` or want to show some special character`(OtpPinFieldInputType.custom)` |
| otpPinInputCustom | String | "*" | Special character to mask the pin code. Will only work if  uses `otpPinFieldInputType` is set to `OtpPinFieldInputType.custom`. |
| onSubmit | void Function(String) | | Callback when the max length of pin code is reached. |
| otpPinFieldStyle | OtpPinFieldStyle| OtpPinFieldStyle() | Customization for the individual pin boxes. Check `OtpPinFieldStyle` for possible options. |
| fieldHeight | double | 45.0 | Height of pin boxes. |
| fieldWidth | double | 70.0 | Width of pin boxes. |
| otpPinFieldDecoration | OtpPinFieldDecoration| OtpPinFieldDecoration.underlinedPinBoxDecoration | Predefine customization for the individual pin boxes. Check `OtpPinFieldStyle` for possible options and use `OtpPinFieldDecoration.custom` for fully customization like boarder radius,width, active and default otp_pin_field colors and etc..  |
| keyboardType | TextInputType | TextInputType.number | The type of the input keyboard |
| autofocus | bool | false | Autofocus on view entered |

# Example

```
 OtpPinField(
              otpPinFieldInputType: OtpPinFieldInputType.custom,    // OtpPinFieldInputType.none || OtpPinFieldInputType.password || OtpPinFieldInputType.custom
              otpPinInputCustom: "\$",  // A String which you want to show when you use 'inputType: OtpPinFieldInputType.custom, '
              onSubmit: (text) {
                print( 'Entered pin is $text');     // return the entered pin
              },
              
              // to decorate your Otp_Pin_Field 
              otpPinFieldStyle: OtpPinFieldStyle(
                 defaultFieldBorderColor: Colors.blue,   // border color for inactive/unfocused Otp_Pin_Field
                activeFieldBorderColor: Colors.red, // border color for active/focused Otp_Pin_Field
                  defaultFieldBackgroundColor: Colors.pinkAccent,   // Background Color for inactive/unfocused Otp_Pin_Field
                activeFieldBackgroundColor: Colors.cyanAccent,    // Background Color for active/focused Otp_Pin_Field
              ),
              fieldCount: 4,  // no of pin field 
              highlightBorder: true,  // want to highlight focused/active Otp_Pin_Field
              fieldWidth: 50,   //to give width to your Otp_Pin_Field
              fieldHeight: 50,  //to give height to your Otp_Pin_Field
              keyboardType: TextInputType.text,    // type of keyboard you want 
              autoFocus: false,   //want to open keyboard or not
              
              // predefine decorate of pinField use  OtpPinFieldDecoration.defaultPinBoxDecoration||OtpPinFieldDecoration.underlinedPinBoxDecoration||OtpPinFieldDecoration.roundedPinBoxDecoration
              //use OtpPinFieldDecoration.custom  (by using this you can make Otp_Pin_Field according to yourself like you can give fieldBorderRadius,fieldBorderWidth and etc things)
              otpPinFieldDecoration: OtpPinFieldDecoration.defaultPinBoxDecoration, 
              
  )
```

refer to `example/lib/main.dart`

#### Different Shapes

<img src="https://raw.githubusercontent.com/shivbo96/otp_pin_field/main/images/1.png" width="250" height="480">
<img src="https://raw.githubusercontent.com/shivbo96/otp_pin_field/main/images/2.png" width="250" height="480">
<img src="https://raw.githubusercontent.com/shivbo96/otp_pin_field/main/images/3.png" width="250" height="480">
<img src="https://raw.githubusercontent.com/shivbo96/otp_pin_field/main/images/4.png" width="250" height="480">
<img src="https://raw.githubusercontent.com/shivbo96/otp_pin_field/main/images/5.png" width="250" height="480">
<img src="https://raw.githubusercontent.com/shivbo96/otp_pin_field/main/images/6.png" width="250" height="480">
<img src="https://raw.githubusercontent.com/shivbo96/otp_pin_field/main/images/7.png" width="250" height="480">
<img src="https://raw.githubusercontent.com/shivbo96/otp_pin_field/main/images/8.png" width="250" height="480">

## More information
[Pub package](https://pub.dartlang.org/packages/otp_pin_field)
[Flutter documentation](https://flutter.io/).
