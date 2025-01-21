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
import 'package:foodly_ui/sizes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final Duration _animationDuration = const Duration(milliseconds: 400);

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

  void _showComingSoonMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Fonctionnalité bientôt disponible !',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          // Background Design Elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          // Main Content
          LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ZAppSizes.defaultSpace,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: ZAppSizes.appBarHeight * 1.2),
                        // Logo with Animation
                        TweenAnimationBuilder(
                          duration: _animationDuration,
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (context, double value, child) {
                            return Transform.scale(
                              scale: value,
                              child: child,
                            );
                          },
                          child: Image(
                            height: 120,
                            image: AssetImage("assets/images/logo.png"),
                          ),
                        ),
                        const SizedBox(height: ZAppSizes.spaceBtwItems),
                        // Welcome Text
                        FadeTransition(
                          opacity: _animationController,
                          child: Text(
                            "Bienvenue sur Zakatuk",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: ZAppSizes.sm),
                        Text(
                          "Votre compagnon de confiance pour la Zakat",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: ZAppSizes.spaceBtwSections),

                        // Sign In Form
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            children: [
                              const SignInForm(),
                              const SizedBox(height: ZAppSizes.spaceBtwItems),

                              // Divider
                              Row(
                                children: [
                                  Expanded(
                                      child: Divider(
                                          color:
                                              Colors.white.withOpacity(0.2))),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      "Ou continuer avec",
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.6)),
                                    ),
                                  ),
                                  Expanded(
                                      child: Divider(
                                          color:
                                              Colors.white.withOpacity(0.2))),
                                ],
                              ),

                              const SizedBox(height: ZAppSizes.spaceBtwItems),

                              // Social Login Buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildSocialButton(
                                    "assets/icons/google.svg",
                                    () => _showComingSoonMessage(context),
                                  ),
                                  const SizedBox(
                                      width: ZAppSizes.spaceBtwItems),
                                  _buildSocialButton(
                                    "assets/icons/facebook.svg",
                                    () => _showComingSoonMessage(context),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: ZAppSizes.spaceBtwItems),

                        // Sign Up Link
                        RichText(
                          text: TextSpan(
                            text: "Vous n'avez pas de compte? ",
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.8)),
                            children: [
                              TextSpan(
                                text: "S'inscrire",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Version text at bottom
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            'Version de test',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String iconPath, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SvgPicture.asset(
            iconPath,
            height: 24,
            width: 24,
          ),
        ),
      ),
    );
  }
}
