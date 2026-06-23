import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/services/user_service.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/types/user.dart';
import 'package:base42_events_mobile/widgets/common/custom_text_fields.dart';
import 'package:base42_events_mobile/widgets/common/page_header.dart';
import 'package:base42_events_mobile/widgets/discard_changes_dialog.dart';
import 'package:base42_events_mobile/widgets/profile/source_modal.dart';
import 'package:base42_events_mobile/widgets/profile_picture_picker.dart';
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
  final ImagePicker _picker = ImagePicker();
  final UserService _userService = UserService();

  late final List<UserFieldConfig> _fields;
  late final Map<String, TextEditingController> _controllers;

  XFile? _selectedImage;
  bool _isLoading = false;
  bool _hasChanges = false;
  bool _initialized = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final user = context.read<AuthProvider>().currentUser;
    _fields = [
      UserFieldConfig(
        key: 'username',
        label: 'Username',
        originalValue: user?.username ?? '',
      ),
      UserFieldConfig(
        key: 'firstName',
        label: 'First Name',
        originalValue: user?.firstName ?? '',
      ),
      UserFieldConfig(
        key: 'lastName',
        label: 'Last Name',
        originalValue: user?.lastName ?? '',
      ),
    ];
    _controllers = {
      for (final field in _fields)
        field.key: TextEditingController(text: field.originalValue)
          ..addListener(_onFieldChanged),
    };
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _onFieldChanged() {
    final hasChanges =
        _fields.any((f) => _controllers[f.key]!.text != f.originalValue) ||
        _selectedImage != null ||
        _isDeleting;
    if (hasChanges != _hasChanges) {
      setState(() => _hasChanges = hasChanges);
    }
  }

  Future<void> _pickImage() async {
    final source = await showImageSourceModal(context);
    if (source == null) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
          _isDeleting = false;
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

  void _handleDeleteProfilePicture() {
    setState(() {
      _selectedImage = null;
      _isDeleting = true;
      _hasChanges = true;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final token = authProvider.token;

      if (token == null) {
        throw Exception('Not authenticated');
      }

      String? changedValue(String key) {
        final field = _fields.firstWhere((f) => f.key == key);
        final newVal = _controllers[key]!.text.trim();
        return newVal != field.originalValue ? newVal : null;
      }

      final changedFields = UpdateProfileBody(
        username: changedValue('username'),
        firstName: changedValue('firstName'),
        lastName: changedValue('lastName'),
      );

      OptionalProfilePicture<XFile?>? profileImageChange;
      if (_isDeleting) {
        profileImageChange = const OptionalProfilePicture.value(null);
      } else if (_selectedImage != null) {
        profileImageChange = OptionalProfilePicture.value(_selectedImage);
      }

      await _userService.updateUserProfile(
        token: token,
        userId: authProvider.currentUser!.id,
        changedFields: changedFields,
        profileImage: profileImageChange,
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
                PageHeader(
                  title: 'Edit Profile',
                  onBack: () async {
                    final shouldPop = await _onWillPop();
                    if (shouldPop && context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
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
                            onDelete: _handleDeleteProfilePicture,
                            initials: _buildInitials(),
                            isDeleting: _isDeleting,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'PERSONAL INFORMATION',
                            style: context.textStyles.titleMedium?.semiBold
                                .withColor(
                                  colorScheme.onSurface.withValues(alpha: 0.8),
                                ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.62),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: colorScheme.outline.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              children: [
                                for (int i = 0; i < _fields.length; i++) ...[
                                  if (i > 0) const SizedBox(height: 20),
                                  CustomTextField(
                                    controller: _controllers[_fields[i].key]!,
                                    label: _fields[i].label,
                                  ),
                                ],
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
                                backgroundColor: colorScheme.primary,
                                disabledBackgroundColor: colorScheme.primary
                                    .withValues(alpha: 0.3),
                                foregroundColor: colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              colorScheme.onPrimary,
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
                                          .withColor(
                                            !_hasChanges
                                                ? colorScheme.onPrimary
                                                      .withValues(alpha: 0.3)
                                                : colorScheme.onPrimary,
                                          ),
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
