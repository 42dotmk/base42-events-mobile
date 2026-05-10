import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/profile/picture_source_option.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource?> showImageSourceModal(BuildContext context) {
  return showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;
      return Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Profile Photo',
              style: context.textStyles.titleLarge?.bold.withColor(
                colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SourceOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Take Photo',
                  color: colorScheme.primary,
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                SourceOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  color: colorScheme.primary,
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
