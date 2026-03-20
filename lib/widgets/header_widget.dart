import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  const HeaderWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          //ova da se zameni so logo
          children: [
            TextSpan(
              text: 'BASE',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: brand?.neonCyan ?? colorScheme.primary,
                letterSpacing: 4,
              ),
            ),
            TextSpan(
              text: '42',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: brand?.neonYellow ?? colorScheme.secondary,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
