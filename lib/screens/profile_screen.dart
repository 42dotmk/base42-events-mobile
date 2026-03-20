import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isKeycloakLoading = false;

  void _registerWithKeycloak(BuildContext context) async {
    try {
      setState(() {
        _isKeycloakLoading = true;
      });
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.register();

      if (!context.mounted) return;
      context.go(AppRoutes.profile);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Keycloak registration failed. Please try again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      setState(() {
        _isKeycloakLoading = false;
      });
    }
  }

  void _loginWithKeycloak(BuildContext context) async {
    try {
      setState(() {
        _isKeycloakLoading = true;
      });
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.login();

      if (!context.mounted) return;
      context.go(AppRoutes.profile);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Keycloak login failed. Please try again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      setState(() {
        _isKeycloakLoading = false;
      });
    }
  }

  void _logout(BuildContext context) async {
    try {
      setState(() {
        _isKeycloakLoading = true;
      });
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();

      if (context.mounted) {
        context.go(AppRoutes.home);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isKeycloakLoading = false;
      });
    }
  }

  VoidCallback? _onAuthButtonPressed(
    BuildContext context,
    bool isAuthenticated,
  ) {
    if (_isKeycloakLoading) return null;
    return isAuthenticated
        ? () => _logout(context)
        : () => _loginWithKeycloak(context);
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final authProvider = context.watch<AuthProvider>();
    final isAuthenticated = authProvider.isAuthenticated;

    return Scaffold(
      appBar: const HeaderWidget(),
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.account_circle,
                  size: 120,
                  color:
                      brand?.neonCyan.withValues(alpha: 0.8) ??
                      colorScheme.primary,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      isAuthenticated
                          ? 'Welcome, ${authProvider.currentUser?.username ?? 'User'}!'
                          : 'You are not logged in.',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color:
                                brand?.neonCyan.withValues(alpha: 0.8) ??
                                colorScheme.primary,
                            fontSize:
                                Theme.of(
                                  context,
                                ).textTheme.headlineSmall?.fontSize ??
                                24 * 1.5,
                          ),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _onAuthButtonPressed(context, isAuthenticated),
                  icon: _isKeycloakLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.lock_open_outlined),
                  label: Text(
                    isAuthenticated ? 'Logout' : 'Login',
                    style: TextStyle(
                      color:
                          brand?.neonCyan.withValues(alpha: 0.9) ??
                          Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        brand?.neonCyan.withValues(alpha: 0.9) ??
                        Theme.of(context).colorScheme.primary,
                    side: BorderSide(
                      color:
                          brand?.neonCyan.withValues(alpha: 0.9) ??
                          Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                if (!isAuthenticated)
                  TextButton(
                    onPressed: () => _registerWithKeycloak(context),
                    child: Text(
                      'Don\'t have an account? Sign up',
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
        ),
      ),
    );
  }
}
