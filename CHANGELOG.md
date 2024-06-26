## [0.0.1] -Release
* Initial release, working base functionality.

## [0.0.2] -Release
* Initial release, working functionality.

## [1.0.0] -Release
* Example Added.

## [1.0.1] -Release
* FocusNode issue resolved.

## [1.0.2] -Release
* added onChange while entering the otp.

## [1.0.3] -Release
* added cursor with animation ,accessibility to manage otp pin field spacing and also added custom keyboard option in place on default keyboard

## [1.0.4] -Release
* custom keyboard on submit callback issue resolved.

## [1.0.4+1] -Release
* Removed unused imports to increase Pass static analysis.

## [1.1.0] -Release
* `Stable`  animation ,accessibility to manage otp pin field spacing and also added custom keyboard option in place on default keyboard

## [1.1.0+1] -Release
* Hot fix custom keyboard view

## [1.1.1] -Release
* Hot fix for on change for on custom keyboard

## [1.1.1+1] -Release
* Hot fix for Animation in custom keyboard

## [1.1.1+2] -Release
* Hot fix

## [1.1.2] -Release
* Added functionality to add custom keyboard and also added ability to hide/un-hide the default keyboard of the OS

## [1.1.2+1] -Release
* added function to `clear the text field controller`

## [1.1.2+2] -Release
* (Hot Fix)added function to `clear the text field controller`

## [1.2.0] -Release
* Added ` sms auto fill functionality `

## [1.2.0+1] -Release
* (Hot Fix) added function to `sms auto fill functionality for sms-regex`

## [1.2.0+2] -Release
* documentation updated and minor bug fixes

## [1.2.1] -Release
* fixed minor issue with animated cursor
* added `prefilled color property` in OtpPinFieldStyle  
* documentation updated

## [1.2.2] -Release
* documentation updated

## [1.2.3] -Release
* Added copy paste OTP feature 
* Added `border gradient color property` in OtpPinFieldStyle
* dart formatted

## [1.2.4] -Release
* Added `border gradient color property for active pin field box` in OtpPinFieldStyle
* Added `border gradient color property for filled pin field box` in OtpPinFieldStyle
* Added `border gradient color property for default pin field box` in OtpPinFieldStyle
* dart formatted

## [1.2.5] -Release
feat: Resolve autofillHints for iOS, enable suggestions and autocorrect, manage keyboard for Android

- Resolved the issue with `autofillHints` not working on iOS by properly wrapping TextFields in `AutofillGroup`.
- Enabled `enableSuggestions` and `autocorrect` for better user experience while inputting text.
- Improved keyboard handling for Android to ensure seamless user interaction.
- Added a demo implementation for OTP autofill using `AutofillHints.oneTimeCode` in a TextField.
- Wrapped TextFields in `AutofillGroup` to support autofill functionalities.
- Ensured `enableSuggestions` and `autocorrect` properties are set to true in relevant TextFields.
- Managed keyboard types and behaviors for both iOS and Android to ensure consistent behavior across platforms.
