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
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
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
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome To Base42!',
                        style: context.textStyles.headlineMedium?.bold
                            .withColor(Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Sign in to access all the cool things we got in our Hackerspace!',
                        style: context.textStyles.titleMedium?.withColor(
                          Colors.white.withValues(alpha: 0.68),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _isLoading ? null : _loginWithKeycloak,
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                brand?.neonYellow ?? colorScheme.secondary,
                            foregroundColor: colorScheme.surface,
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
                                    color: colorScheme.surface,
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
                            foregroundColor:
                                brand?.neonCyan ?? colorScheme.primary,
                            side: BorderSide(
                              color: (brand?.neonCyan ?? colorScheme.primary)
                                  .withValues(alpha: 0.5),
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
