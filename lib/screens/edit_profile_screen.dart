import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/services/user_service.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/discard_changes_dialog.dart';
import 'package:base42_events_mobile/widgets/profile_picture_picker.dart';
import 'package:base42_events_mobile/widgets/styled_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final UserService _userService = UserService();

  XFile? _selectedImage;
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    _firstNameController.text = authProvider.currentUser?.firstName ?? '';
    _lastNameController.text = authProvider.currentUser?.lastName ?? '';
    _usernameController.text = authProvider.currentUser?.username ?? '';
    _firstNameController.addListener(_onFieldChanged);
    _lastNameController.addListener(_onFieldChanged);
    _usernameController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
          _hasChanges = true;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    debugPrint(authProvider.token);
    try {
      final authProvider = context.read<AuthProvider>();
      final token = authProvider.token;

      if (token == null) {
        throw Exception('Not authenticated');
      }

      await _userService.updateUserProfile(
        token: token,
        userId: authProvider.currentUser!.id,
        username: _usernameController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        profileImage: _selectedImage,
      );

      await authProvider.refreshCurrentUser();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );

      context.go(AppRoutes.profile);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _buildInitials() {
    final authProvider = context.read<AuthProvider>();
    final username = authProvider.currentUser?.username ?? '';
    final raw = username.trim();
    if (raw.isEmpty) return 'GU';

    final segments = raw
        .split(RegExp(r'[\s._-]+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (segments.isEmpty) return 'GU';

    final displayName = segments
        .map((part) => part[0].toUpperCase() + part.substring(1).toLowerCase())
        .join(' ');

    final parts = displayName.split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final letters = parts.take(2).map((p) => p[0].toUpperCase()).join();
    return letters.isEmpty ? 'GU' : letters;
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;
    return await DiscardChangesDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: brand?.backdropGradient),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 18, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          final shouldPop = await _onWillPop();
                          if (shouldPop && context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      Text(
                        'Edit Profile',
                        style: context.textStyles.headlineMedium?.bold
                            .withColor(Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 24, 18, 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfilePicturePicker(
                            selectedImage: _selectedImage,
                            currentProfilePicture: context
                                .watch<AuthProvider>()
                                .currentUser
                                ?.profilePicture,
                            onTap: _pickImage,
                            initials: _buildInitials(),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'PERSONAL INFORMATION',
                            style: context.textStyles.headlineSmall?.semiBold
                                .withSize(38 / 2)
                                .withColor(Colors.white.withValues(alpha: 0.8)),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.62),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              children: [
                                StyledTextFormField(
                                  controller: _usernameController,
                                  labelText: 'Username',
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your username';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                StyledTextFormField(
                                  controller: _firstNameController,
                                  labelText: 'First Name',
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your first name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                StyledTextFormField(
                                  controller: _lastNameController,
                                  labelText: 'Last Name',
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your last name';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isLoading || !_hasChanges
                                  ? null
                                  : _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    brand?.neonCyan ?? colorScheme.primary,
                                disabledBackgroundColor:
                                    (brand?.neonCyan ?? colorScheme.primary)
                                        .withValues(alpha: 0.3),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      'Save Changes',
                                      style: context
                                          .textStyles
                                          .headlineSmall
                                          ?.bold
                                          .withSize(38 / 2)
                                          .withColor(Colors.white),
                                    ),
                            ),
                          ),
                        ],
                      ),
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
