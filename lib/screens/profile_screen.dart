import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/header_widget.dart';
import 'package:flutter/material.dart';

// TODO: Implement profile screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    return Scaffold(
      appBar: const HeaderWidget(),
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: Column(
          children: [
            const Center(
              child: Text(
                'Profile Screen',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
