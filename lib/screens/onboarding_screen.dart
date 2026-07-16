import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/onboarding/onboarding_action_button.dart';
import '../widgets/onboarding/onboarding_dots.dart';
import '../widgets/onboarding/onboarding_slide.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  final bool showSkip;
  final String? doneButtonLabel;

  const OnboardingScreen({
    super.key,
    required this.onComplete,
    this.showSkip = false,
    this.doneButtonLabel,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

final List<_OnboardingSlideData> _slides = [
  _OnboardingSlideData(
    assetPath: 'assets/onboarding/speaker.jpeg',
    title: 'Welcome to Base42',
    description:
        'Your hackerspace for building, learning, and connecting with curious minds in Skopje.',
  ),
  _OnboardingSlideData(
    assetPath: 'assets/onboarding/stage.jpg',
    title: 'Talks & Conferences',
    description:
        'Professional A/V setup, stage lighting, and seating for up to 120 people. Host or attend world-class events.',
  ),
  _OnboardingSlideData(
    assetPath: 'assets/onboarding/audience.jpeg',
    title: 'Vibrant Community',
    description:
        'Join 1000+ Discord members, weekly meetups, workshops, and game nights with partner organizations.',
  ),
  _OnboardingSlideData(
    assetPath: 'assets/onboarding/workshop-area.jpg',
    title: 'Workshop & Tools',
    description:
        'Electronics benches, soldering stations, 3D printers, and a server rack you can actually tinker with.',
  ),
  _OnboardingSlideData(
    assetPath: 'assets/onboarding/hottub.jpg',
    title: "You're Ready",
    description:
        "Grab a controller, fire up the jacuzzi, and dive into the community. Let's build something together.",
  ),
];

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _next() {
    if (_currentPage == _slides.length - 1) {
      widget.onComplete();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final isLast = _currentPage == _slides.length - 1;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SafeArea(
          child: Column(
            children: [
              if (widget.showSkip)
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.sm,
                    right: AppSpacing.lg,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: widget.onComplete,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.38),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(height: AppSpacing.lg),

              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: _onPageChanged,
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return OnboardingSlide(
                      assetPath: slide.assetPath,
                      title: slide.title,
                      description: slide.description,
                    );
                  },
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      (brand?.deepNavy ?? const Color(0xFF070B12))
                          .withValues(alpha: 0.98),
                    ],
                    stops: const [0.0, 0.36],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  36,
                  AppSpacing.lg,
                  48,
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      OnboardingDots(
                        currentPage: _currentPage,
                        totalPages: _slides.length,
                      ),
                      const Spacer(),
                      OnboardingActionButton(
                        isLast: isLast,
                        onPressed: _next,
                        doneButtonLabel: widget.doneButtonLabel,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlideData {
  final String assetPath;
  final String title;
  final String description;

  const _OnboardingSlideData({
    required this.assetPath,
    required this.title,
    required this.description,
  });
}
