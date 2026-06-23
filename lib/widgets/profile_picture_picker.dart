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
  final VoidCallback? onDelete;
  final String initials;
  final bool isDeleting;

  const ProfilePicturePicker({
    super.key,
    this.selectedImage,
    this.currentProfilePicture,
    required this.onTap,
    this.onDelete,
    required this.initials,
    this.isDeleting = false,
  });

  void _showEnlarged(BuildContext context, String? imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: selectedImage != null
                  ? Image.file(File(selectedImage!.path), fit: BoxFit.contain)
                  : imageUrl != null
                  ? Image.network(imageUrl, fit: BoxFit.contain)
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    String? imageUrl;
    if (selectedImage == null && currentProfilePicture != null && !isDeleting) {
      imageUrl = currentProfilePicture!.getMediumUrl(baseUrl);
    }

    final hasImage = selectedImage != null || imageUrl != null;

    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: hasImage ? () => _showEnlarged(context, imageUrl) : null,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: (colorScheme.secondary).withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: (colorScheme.primary).withValues(alpha: 0.45),
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
          ),
          if (hasImage && onDelete != null)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.red.shade300,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.surface, width: 3),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
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
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colorScheme.surface, width: 3),
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
            .withColor(colorScheme.secondary),
      ),
    );
  }
}
