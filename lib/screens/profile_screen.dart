import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// TODO: Implement profile screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) async {
    try {
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
    }
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
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Text(
                    isAuthenticated
                        ? 'Welcome, ${authProvider.currentUser?.username ?? 'User'}!'
                        : 'You are not logged in.',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color:
                          brand?.neonCyan.withValues(alpha: 0.8) ??
                          colorScheme.primary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isAuthenticated
                      ? () => _logout(context)
                      : () => context.push(AppRoutes.login),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        brand?.deepNavy.withValues(alpha: 0.75) ??
                        colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shadowColor: brand?.neonCyan ?? colorScheme.primary,
                    elevation: 3,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(isAuthenticated ? 'Logout' : 'Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
