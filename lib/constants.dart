import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

const titleColor = Color(0xFF010F07);
// Couleurs principales
const Color primaryColor = Color.fromARGB(
    255, 44, 26, 1); // Noir profond, symbolise la modernité et le sérieux
const Color accentColor =
    Color(0xFF258F0A); // Vert émeraude, rappel de la tradition islamique
const Color textColor =
    Color(0xFF3E3E3E); // Gris foncé pour une lisibilité optimale
const Color backgroundColor =
    Color(0xFFF7F7F7); // Blanc cassé pour un fond doux et accueillant
const thirdColor = Color.fromARGB(255, 203, 137, 62);
const fourthColor = Color.fromARGB(255, 216, 165, 107);

// Couleurs secondaires
const Color secondaryColor = Color(0xFF92580C);
// Brun doré pour évoquer la richesse et la tradition
const Color highlightColor =
    Color(0xFFAC5708); // Orange terre cuite, chaleureux et attrayant
const Color successColor =
    Color(0xFF4CAF50); // Vert clair, pour les actions réussies
const Color errorColor = Color(0xFFD32F2F); // Rouge vif, pour les alertes
// const Color primaryColor = Color(0xFF003366);
// const Color secondBColor = Color.fromARGB(255, 23, 71, 120);

// const Color backgroundColor = Color(0xFFF5F5F5); // Gris très clair

const Color primaryGreen = Color.fromARGB(255, 47, 133, 90);
const Color primaryGold = Color.fromARGB(255, 212, 175, 55);
const Color secondaryWhite = Color.fromARGB(255, 255, 255, 255);
const Color secondaryNavy = Color.fromARGB(255, 44, 62, 80);
const Color accentOrange = Color.fromARGB(255, 244, 162, 97);
const Color neutralGray = Color.fromARGB(255, 234, 234, 234);

// const accentColor = Color(0xFFEF9920);
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

final phoneNumberValidator = MinLengthValidator(8,
    errorText: 'Phone Number must be at least 10 digits long');

// Common Text
final Center kOrText = Center(
    child: Text("Or", style: TextStyle(color: titleColor.withOpacity(0.7))));
final List<String> organizations = [
  "SOS Village d’Enfants Gammarth",
  "Maison des Aînés de La Marsa",
  "Association Tunisienne de Lutte Contre le Cancer (ATCC)",
  "Dar Al Amal (Maison de l’Espoir)",
  "Association Amal pour la Femme et le Développement",
  "Association Tunisienne pour l’Aide aux Malades Mentaux (ATAMM)",
];
