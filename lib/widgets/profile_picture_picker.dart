import 'dart:io';
import 'package:base42_events_mobile/consts/api.dart';
import 'package:base42_events_mobile/models/media.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicturePicker extends StatelessWidget {
  final XFile? selectedImage;
  final Media? currentProfilePicture;
  final VoidCallback onTap;
  final String initials;

  const ProfilePicturePicker({
    super.key,
    this.selectedImage,
    this.currentProfilePicture,
    required this.onTap,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    String? imageUrl;
    if (selectedImage == null && currentProfilePicture != null) {
      imageUrl = currentProfilePicture!.getMediumUrl(baseUrl);
    }

    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: (brand?.neonCyan ?? colorScheme.secondary).withValues(
                alpha: 0.18,
              ),
              borderRadius: BorderRadius.circular(60),
              border: Border.all(
                color: (brand?.neonCyan ?? colorScheme.secondary).withValues(
                  alpha: 0.45,
                ),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(58),
              child: selectedImage != null
                  ? Image.file(File(selectedImage!.path), fit: BoxFit.cover)
                  : imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildInitialsAvatar(context, brand, colorScheme),
                    )
                  : _buildInitialsAvatar(context, brand, colorScheme),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: brand?.neonCyan ?? colorScheme.primary,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: brand?.deepNavy ?? colorScheme.surface,
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialsAvatar(
    BuildContext context,
    BrandTheme? brand,
    ColorScheme colorScheme,
  ) {
    return Center(
      child: Text(
        initials,
        style: context.textStyles.headlineMedium?.bold
            .withSize(48)
            .withColor(brand?.neonCyan ?? colorScheme.secondary),
      ),
    );
  }
}
