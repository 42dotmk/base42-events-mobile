import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isKeycloakLoading = false;
  File? _avatarImage;
  final ImagePicker _picker = ImagePicker();

  final List<Event> _attendedEvents = [
    Event(
      id: 1,
      title: 'Flutter Workshop',
      description: 'Learn Flutter basics and build your first app',
      summary: 'Introduction to Flutter development',
      slug: 'flutter-workshop',
      start: DateTime.now().subtract(const Duration(days: 30)),
      locale: 'en',
      tags: [],
    ),
    Event(
      id: 2,
      title: 'Hackerspace Meetup',
      description: 'Monthly meetup for builders and makers',
      summary: 'Community meetup at Base42',
      slug: 'hackerspace-meetup',
      start: DateTime.now().subtract(const Duration(days: 15)),
      locale: 'en',
      tags: [],
    ),
    Event(
      id: 3,
      title: '3D Printing Workshop',
      description: 'Learn how to use 3D printers and design your models',
      summary: 'Hands-on 3D printing',
      slug: '3d-printing-workshop',
      start: DateTime.now().subtract(const Duration(days: 7)),
      locale: 'en',
      tags: [],
    ),
  ];

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

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _avatarImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
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
    final textTheme = Theme.of(context).textTheme;
    final authProvider = context.watch<AuthProvider>();
    final isAuthenticated = authProvider.isAuthenticated;

    return Scaffold(
      appBar: const HeaderWidget(),
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  _buildAvatarSection(brand, colorScheme, isAuthenticated),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: Text(
                      isAuthenticated
                          ? authProvider.currentUser?.username ?? 'User'
                          : 'Guest User',
                      style: textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (!isAuthenticated) ...[
                    Center(
                      child: Text(
                        'Login to access your profile',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  Center(child: _buildAuthButton(brand, isAuthenticated)),
                  if (!isAuthenticated) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Center(
                      child: TextButton(
                        onPressed: () => _registerWithKeycloak(context),
                        child: Text(
                          'Don\'t have an account? Sign up',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                brand?.neonCyan.withValues(alpha: 0.7) ??
                                colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isAuthenticated)
              Expanded(
                child: ListView(
                  padding: AppSpacing.paddingLg,
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    _buildAttendedEventsSection(brand, textTheme),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection(
    BrandTheme? brand,
    ColorScheme colorScheme,
    bool isAuthenticated,
  ) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: brand?.neonCyan ?? colorScheme.primary,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: (brand?.neonCyan ?? colorScheme.primary).withValues(
                    alpha: 0.3,
                  ),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: _avatarImage != null
                  ? Image.file(_avatarImage!, fit: BoxFit.cover)
                  : Container(
                      color: brand?.deepTeal.withValues(alpha: 0.3),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: brand?.neonCyan ?? colorScheme.primary,
                      ),
                    ),
            ),
          ),
          if (isAuthenticated)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: brand?.neonYellow ?? Colors.yellow,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: brand?.deepNavy ?? colorScheme.surface,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: brand?.deepNavy ?? Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAuthButton(BrandTheme? brand, bool isAuthenticated) {
    return TextButton.icon(
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
    );
  }

  Widget _buildAttendedEventsSection(BrandTheme? brand, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history, color: brand?.neonYellow, size: 24),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '> Event History',
              style: textTheme.headlineSmall?.copyWith(
                color: brand?.neonYellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ..._attendedEvents.map(
          (event) => _buildEventHistoryCard(event, brand, textTheme),
        ),
      ],
    );
  }

  Widget _buildEventHistoryCard(
    Event event,
    BrandTheme? brand,
    TextTheme textTheme,
  ) {
    final daysAgo = DateTime.now().difference(event.start).inDays;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: brand?.deepTeal.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color:
              brand?.neonCyan.withValues(alpha: 0.3) ??
              Colors.cyan.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: brand?.neonCyan.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              Icons.event_available,
              color: brand?.neonCyan,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  daysAgo == 0
                      ? 'Today'
                      : daysAgo == 1
                      ? 'Yesterday'
                      : '$daysAgo days ago',
                  style: textTheme.bodySmall?.copyWith(
                    color: brand?.neonYellow.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: brand?.neonYellow, size: 24),
        ],
      ),
    );
  }
}
