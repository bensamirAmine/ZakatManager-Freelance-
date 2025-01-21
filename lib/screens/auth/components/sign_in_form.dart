import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/screens/Delivered/DeliveryOrdersPage.dart';
import 'package:provider/provider.dart';
import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/entry_point.dart';
import 'package:foodly_ui/sizes.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String _selectedRole = 'User';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SegmentedControl pour le choix de rôle
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      // Add constraints to control the maximum width
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.9),
                      child: CupertinoSegmentedControl<String>(
                        groupValue: _selectedRole,
                        children: {
                          'User': Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 18,
                                  color: _selectedRole == 'User'
                                      ? Colors.white
                                      : primaryColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Individu',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: _selectedRole == 'User'
                                        ? Colors.white
                                        : primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          'Livreur': Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.business_outlined,
                                  size: 18,
                                  color: _selectedRole == 'Livreur'
                                      ? Colors.white
                                      : primaryColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Entreprise',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: _selectedRole == 'Livreur'
                                        ? Colors.white
                                        : primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        },
                        onValueChanged: (String newValue) {
                          setState(() {
                            _selectedRole = newValue;
                          });
                        },
                        borderColor: Colors.transparent,
                        selectedColor: primaryColor,
                        unselectedColor: Colors.white,
                        padding: const EdgeInsets.all(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Affichage dynamique selon le rôle sélectionné
                  if (_selectedRole == 'User') ...[
                    _buildUserForm(authProvider),
                  ] else if (_selectedRole == 'Livreur') ...[
                    _buildDeliveryForm(authProvider),
                  ],
                  // else if (_selectedRole == 'Livreur') ...[
                  //   _buildDeliveryForm(authProvider),
                  // ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Formulaire pour les utilisateurs (User)
  Widget _buildUserForm(AuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email input field
        _buildInputField(
          label: 'Email',
          icon: Icons.email,
          onChanged: (value) => email = value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Merci de saisir votre email';
            }
            return null;
          },
        ),
        const SizedBox(height: ZAppSizes.spaceBtwItems),

        // Password input field
        _buildInputField(
          label: 'Mot de passe',
          icon: Icons.lock,
          obscureText: true,
          onChanged: (value) => password = value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Merci de saisir votre mot de passe';
            }
            return null;
          },
        ),
        // const SizedBox(height: ),

        // Login button for User
        // Row(
        //   children: [
        //     Row(
        //       children: [
        //         Checkbox(
        //           value: true,
        //           onChanged: (value) {},
        //         ),
        //         const Text('Se souvenir de moi'),
        //       ],
        //     )
        //   ],
        // ),
        const SizedBox(height: ZAppSizes.spaceBtwItems),
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 0, 255, 255).withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: authProvider.isLoading
                ? const SizedBox(
                    height: 48,
                    width: 48,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 0, 255, 255)),
                      strokeWidth: 3,
                    ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 0, 153, 153),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 16.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ).copyWith(
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Color.fromARGB(255, 0, 179, 179);
                          }
                          if (states.contains(MaterialState.hovered)) {
                            return Color.fromARGB(255, 0, 166, 166);
                          }
                          return null;
                        },
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await authProvider.login(email, password);

                          if (authProvider.isLoggedIn) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(authProvider.message),
                                  backgroundColor:
                                      Color.fromARGB(255, 0, 153, 153),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: const EdgeInsets.all(16),
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EntryPoint(),
                                ),
                              );
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(authProvider.error),
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 76, 76),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: const EdgeInsets.all(16),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('An error occurred: $e'),
                                backgroundColor:
                                    Color.fromARGB(255, 255, 76, 76),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: const EdgeInsets.all(16),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: const Text(
                      'Se connecter',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // Formulaire pour les livreurs (Livreur)
  Widget _buildDeliveryForm(AuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(
          label: 'Email',
          icon: Icons.email,
          onChanged: (value) => email = value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Password input field
        _buildInputField(
          label: 'Password',
          icon: Icons.lock,
          obscureText: true,
          onChanged: (value) => password = value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),

        // Login button for Livreur
        Center(
          child: authProvider.isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await authProvider.livreurlogin(email, password);

                      if (authProvider.isLoggedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(authProvider.message)),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DeliveryOrdersPage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(authProvider.error)),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Sign In as Bank Client',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
        ),
      ],
    );
  }

  // Champ d'entrée avec icône
  Widget _buildInputField({
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.white70,
          ),
          suffixIcon: obscureText
              ? Icon(
                  Icons.visibility,
                  color: Colors.white70,
                )
              : null,
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red.withOpacity(0.5),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        obscureText: obscureText,
        onChanged: onChanged,
        validator: validator,
        cursorColor: Colors.blue,
      ),
    );
  }
}
