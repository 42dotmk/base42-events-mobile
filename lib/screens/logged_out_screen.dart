import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoggedOutScreen extends StatefulWidget {
  const LoggedOutScreen({super.key});

  @override
  State<LoggedOutScreen> createState() => _LoggedOutScreenState();
}

class _LoggedOutScreenState extends State<LoggedOutScreen> {
  bool _isLoading = false;

  Future<void> _loginWithKeycloak() async {
    try {
      setState(() => _isLoading = true);
      await Provider.of<AuthProvider>(context, listen: false).login();
      if (!mounted) return;
      context.go(AppRoutes.home);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Keycloak login failed. Please try again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _registerWithKeycloak() async {
    try {
      setState(() => _isLoading = true);
      await Provider.of<AuthProvider>(context, listen: false).register();
      if (!mounted) return;
      context.go(AppRoutes.home);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Keycloak registration failed. Please try again.',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? colorScheme.secondary : colorScheme.primary;

    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.62,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome To Base42!',
                        style: context.textStyles.headlineMedium?.bold
                            .withColor(colorScheme.onSurface),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Sign in to access all the cool things we got in our Hackerspace!',
                        style: context.textStyles.titleMedium?.withColor(
                          colorScheme.onSurface.withValues(alpha: 0.68),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _isLoading ? null : _loginWithKeycloak,
                          style: FilledButton.styleFrom(
                            backgroundColor: primaryAccent,
                            foregroundColor: colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colorScheme.onPrimary,
                                  ),
                                )
                              : Text(
                                  'Login',
                                  style:
                                      context.textStyles.titleMedium?.semiBold,
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : _registerWithKeycloak,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorScheme.primary,
                            side: BorderSide(
                              color: colorScheme.primary.withValues(alpha: 0.5),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Register',
                            style: context.textStyles.titleMedium?.semiBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
