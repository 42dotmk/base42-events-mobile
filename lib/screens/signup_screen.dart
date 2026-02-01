import 'package:base42_events_mobile/models/user.dart';
import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/services/user_service.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String _username = '';
  String _email = '';
  String _password = '';
  String _error = '';

  void _signup() async {
    try {
      User? createdUser = await UserService().addUser(
        _email,
        _username,
        _password,
      );

      if (!mounted) return;

      if (createdUser != null) {
        context.go(AppRoutes.home);
      } else {
        setState(() {
          _error = 'Signup failed. Please try again.';
        });
      }
    } on Exception catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Signup',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: brand?.deepNavy,
      ), // TO-DO: Change to reusable header widget
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_error.isNotEmpty)
                Column(
                  children: [
                    Text(
                      _error,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              Padding(
                padding: AppSpacing.paddingMd,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 0,
                        bottom: 15.0,
                      ),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter valid username e.g. Paul',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _username = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 0,
                        bottom: 15.0,
                      ),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter valid email id as abc@gmail.com',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextField(
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter secure password',
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    Container(
                      height: 50,
                      width: 180,
                      decoration: BoxDecoration(
                        color:
                            brand?.neonCyan.withValues(alpha: 0.5) ??
                            Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: () => _signup(),
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextButton(
                      onPressed: () {
                        context.go(AppRoutes.login);
                      },
                      child: Text(
                        'Already have an account? Login',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              brand?.neonCyan.withValues(alpha: 0.5) ??
                              Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
