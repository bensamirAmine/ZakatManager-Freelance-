import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

const titleColor = Color(0xFF010F07);
const Color primaryColor = Color(0xFF003366);
const Color secondBColor = Color.fromARGB(255, 23, 71, 120);

const Color backgroundColor = Color(0xFFF5F5F5); // Gris très clair

const secondColor = Color.fromARGB(255, 235, 190, 139);
const thirdColor = Color.fromARGB(255, 241, 213, 182);

const Color primaryGreen = Color.fromARGB(255, 47, 133, 90);
const Color primaryGold = Color.fromARGB(255, 212, 175, 55);
const Color secondaryWhite = Color.fromARGB(255, 255, 255, 255);
const Color secondaryNavy = Color.fromARGB(255, 44, 62, 80);
const Color accentOrange = Color.fromARGB(255, 244, 162, 97);
const Color neutralGray = Color.fromARGB(255, 234, 234, 234);

const accentColor = Color(0xFFEF9920);
const bodyTextColor = Color(0xFF868686);
const inputColor = Color(0xFFFBFBFB);
const double smalltitle = 16;
const double pricipaltitle = 20;
const double normaltext = 10;

const double defaultPadding = 16;
const Duration kDefaultDuration = Duration(milliseconds: 250);

const TextStyle kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

const EdgeInsets kTextFieldPadding = EdgeInsets.symmetric(
  horizontal: defaultPadding,
  vertical: defaultPadding,
);

// Text Field Decoration
const OutlineInputBorder kDefaultOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(6)),
  borderSide: BorderSide(
    color: Color(0xFFF3F2F2),
  ),
);

const InputDecoration otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.zero,
  counterText: "",
  errorStyle: TextStyle(height: 0),
);

const kErrorBorderSide = BorderSide(color: Colors.red, width: 1);

// Validator
final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-/])',
      errorText: 'Passwords must have at least one special character')
]);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'Email is required'),
  EmailValidator(errorText: 'Enter a valid email address')
]);

final requiredValidator =
    RequiredValidator(errorText: 'This field is required');
final matchValidator = MatchValidator(errorText: 'passwords do not match');

final phoneNumberValidator = MinLengthValidator(10,
    errorText: 'Phone Number must be at least 10 digits long');

// Common Text
final Center kOrText = Center(
    child: Text("Or", style: TextStyle(color: titleColor.withOpacity(0.7))));
