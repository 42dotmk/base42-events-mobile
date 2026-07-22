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
        'A community-driven hackerspace for tech enthusiasts, makers, and developers.\nLearn, build, and collaborate.',
  ),
  _OnboardingSlideData(
    assetPath: 'assets/onboarding/lounge.jpg',
    title: 'Open to Everyone',
    description:
        'Explore technology, work on open-source projects, attend meetups and workshops, or just hang out with friendly, geeky people.',
  ),
  _OnboardingSlideData(
    assetPath: 'assets/onboarding/workshop-area.jpg',
    title: 'Tools & Equipment',
    description:
        'Full access to the server rack, 3D printer, microcontrollers, and maker tools.\nEverything you need to build.',
  ),
  _OnboardingSlideData(
    assetPath: 'assets/onboarding/hottub.jpg',
    title: 'More Than Just Tech',
    description:
        'Use the kitchen, grab coffee, play board games, or relax with PlayStation. Work hard, unwind harder.',
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
    final colorScheme = Theme.of(context).colorScheme;
    final isLast = _currentPage == _slides.length - 1;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SafeArea(
          child: Column(
            children: [
              if (widget.showSkip && !isLast)
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
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
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
