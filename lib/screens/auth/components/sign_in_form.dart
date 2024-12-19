import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/screens/Delivered/DeliveryOrdersPage.dart';
import 'package:provider/provider.dart';
import 'package:foodly_ui/A-providers/AuthProvider.dart';
import 'package:foodly_ui/entry_point.dart';

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
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SegmentedControl pour le choix de rôle
                  Center(
                    child: CupertinoSegmentedControl<String>(
                      groupValue: _selectedRole,
                      children: {
                        'User': Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Indivdual',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                        'Livreur': Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Company',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      },
                      onValueChanged: (String newValue) {
                        setState(() {
                          _selectedRole = newValue;
                        });
                      },
                      borderColor: secondColor,
                      selectedColor: secondColor,
                      unselectedColor: Colors.white,
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

        // Login button for User
        Center(
          child: authProvider.isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await authProvider.login(email, password);

                      if (authProvider.isLoggedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(authProvider.message)),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EntryPoint(),
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
                    'Sign In as User',
                    style: TextStyle(fontSize: 16),
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
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
