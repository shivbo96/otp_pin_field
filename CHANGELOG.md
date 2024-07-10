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
- Improved keyboard handling for Android to ensure seamless user interaction.
- Added a demo implementation for OTP autofill using `AutofillHints.oneTimeCode` in a TextField.
- Wrapped TextFields in `AutofillGroup` to support autofill functionalities.
- Ensured `enableSuggestions` and `autocorrect` properties are set to true in relevant TextFields.
- Managed keyboard types and behaviors for both iOS and Android to ensure consistent behavior across platforms.

## [1.2.5+2] -Release
feat: Add flexibility to change border width for custom OtpPinFieldDecoration and handle OTP copy-paste scenarios

- Added support to change border width in custom `OtpPinFieldDecoration` for enhanced customization.
- Improved OTP copy-paste functionality:
    - Handled cases where copied string includes non-numeric characters.
    - Managed scenarios where copied numeric string is shorter than the max length of the OTP PinField.
- Updated documentation for the `beforeTextPaste` function to provide clear guidance on usage.
- Updated CHANGELOG and README to reflect new features and improvements.

Documentation:
- Added details about new border width customization option in `OtpPinFieldDecoration`.
- Provided examples and explanation on handling copy-paste functionality for OTP fields.

## [1.2.6] -Release
- Resolved an issue where the keyboard would not open after clearing all text fields.

## [1.2.6+1] -Release
- Documents updated.

## [1.2.7] -Release
feat: Add support for custom border colors and width in OTP pin field

- Added ability to customize border colors using defaultFieldBorderColor and activeFieldBorderColor properties.
- Introduced fieldBorderWidth property to set the width of the border.
- Updated documentation to guide users on how to achieve custom border effects.

## [1.2.7+1] -Release
- Documents updated.

## [1.2.8] - 2024-07-03

### Added
- Box border support for `defaultPinBoxDecoration`, `roundedPinBoxDecoration`, and `custom` in `otpPinFieldDecoration`.
- Enhanced customization options for OTP pin fields, including border radius and box shadow properties.

### Fixed
- Clarified the usage of `borderRadius` property with `otpPinFieldDecoration.custom` to avoid confusion when using `underlinedPinBoxDecoration`.

### Updated
- Updated documentation and example code to demonstrate new features and proper usage of custom decorations.



#### [Version 1.2.8+1] - 2024-07-09

**Improvements:**
- Refactored `OtpPinFieldState` to streamline decoration handling.
- Removed `foregroundBoxDecoration` and integrated its logic into `BoxDecoration`.
- Improved handling of `fieldBorderGradient` with a fallback mechanism.
- Enhanced code readability and maintainability.

**Bug Fixes:**
- Fixed potential issues with the decoration logic by consolidating it within `BoxDecoration`.
- Addressed minor inconsistencies in field highlighting and cursor behavior.


#### [Version 1.2.9] - 2024-07-09

**Improvements:**
- Added handling for keyboard not opening issue in webview apps.
- Improved focus management for webview apps in the `onFieldFocus` method.

**Bug Fixes:**
- Fixed potential issues with the decoration logic by consolidating it within `BoxDecoration`.
- Addressed minor inconsistencies in field highlighting and cursor behavior.

**Documentation:**
- Updated README file with the latest changes and usage instructions.
- Updated changelog file with version 1.2.9 release notes.