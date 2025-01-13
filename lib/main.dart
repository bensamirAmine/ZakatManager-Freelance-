 import 'package:flutter/material.dart';
import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/A-providers/LivreurProvider.dart';
import 'package:foodly_ui/A-providers/MenuProvider.dart';
import 'package:foodly_ui/A-providers/PanierProvider.dart';
import 'package:foodly_ui/A-providers/RestaurantProvider.dart';
import 'package:foodly_ui/A-providers/SearchProvider.dart';
import 'package:foodly_ui/A-providers/SupplementProvider.dart';
import 'package:foodly_ui/A-providers/UserProvider.dart';
import 'package:foodly_ui/A-providers/ZakatProvider.dart';
import 'package:foodly_ui/A-providers/commandeprovider.dart';
import 'package:foodly_ui/screens/auth/sign_in_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('auth_token');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ZakatProvider()),
        ChangeNotifierProvider(create: (context) => RestaurantProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => MenuProvider()),
        ChangeNotifierProvider(create: (context) => PanierProvider()),
        ChangeNotifierProvider(create: (context) => SupplementProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => CommandeProvider()),
        ChangeNotifierProvider(create: (context) => LivreurProvider()),
      ],
      child: MyApp(isAuthenticated: token != null),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;

  const MyApp({super.key, required this.isAuthenticated});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: bodyTextColor),
          bodySmall: TextStyle(color: bodyTextColor),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.all(defaultPadding),
          hintStyle: TextStyle(color: bodyTextColor),
        ),
      ),
      home:
          //  isAuthenticated ? const EntryPoint() :
          const SignInScreen(),
    );
  }
}
