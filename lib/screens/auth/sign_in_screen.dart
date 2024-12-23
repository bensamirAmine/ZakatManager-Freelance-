import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/screens/AnimatedText.dart';
import 'package:provider/provider.dart';

import '../../components/buttons/socal_button.dart';
import '../../constants.dart';
import 'sign_up_screen.dart';
import 'components/sign_in_form.dart';



class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: const SizedBox(),
      //   title: const Text(
      //     "Zakat Login",
      //     style: TextStyle(color: inputColor, fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: secondColor,
      //   elevation: 2,
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding * 5),
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: defaultPadding + 5),

                    // Animated Logo
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1 + 0.3 * _animationController.value,
                          child: child,
                        );
                      },
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: secondColor,
                        child: Image.asset(
                          'assets/images/logo2.png', // Chemin de l'image
                          fit: BoxFit.cover,
                          width: 100, // Ajustez la taille si nécessaire
                          height: 100,
                        ),
                      ),
                    ),

                    const SizedBox(height: defaultPadding),
                    // Welcome Text Section
                    // AnimatedBuilder(
                    //   animation: _animationController,
                    //   builder: (context, child) {
                    //     return Transform.scale(
                    //       scale: 1 + 0.3 * _animationController.value,
                    //       child: child,
                    //     );
                    //   },
                    //   child:
                    Text(
                      "Welcome to Zakat App",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                    // ),
                    const SizedBox(height: defaultPadding),

                    Center(
                      child: Column(
                        children: [
                          // Autres widgets
                          const AnimatedText(),
                        ],
                      ),
                    ),
                    const SizedBox(height: defaultPadding * 2),

                    // const SizedBox(height: 8),
                    const SignInForm(),
                    const SizedBox(height: defaultPadding * 2),

                    Center(
                      child: Text(
                        "OR",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding),

                    SocalButton(
                      press: () {
                        Provider.of<AuthProvider>(context, listen: false)
                            .signInWithGoogle(context);
                      },
                      text: "Sign in with Google",
                      color: Color.fromARGB(255, 60, 101, 165),
                      icon: SvgPicture.asset(
                        'assets/icons/google.svg',
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    // SocalButton(
                    //   press: () {},
                    //   text: "Sign in with Facebook",
                    //   color: const Color(0xFF395998),
                    //   icon: SvgPicture.asset(
                    //     'assets/icons/facebook.svg',
                    //     colorFilter: const ColorFilter.mode(
                    //       Color(0xFF395998),
                    //       BlendMode.srcIn,
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: defaultPadding),

                    // Sign Up Text Section
                    Center(
                      child: Text.rich(
                        TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.w600),
                          text: "Don’t have an account? ",
                          children: <TextSpan>[
                            TextSpan(
                              text: "Create one here.",
                              style: const TextStyle(
                                  color: secondColor,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen(),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.green[700],
                      thickness: 1.5,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: secondColor,
                  borderRadius: BorderRadius.circular(15), // Ajout du rayon
                ),
                child: Center(
                  child: Text(
                    "Sign in to manage your donations\nand support those in need with\ntransparency and ease.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.green[700],
                thickness: 1.5,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
