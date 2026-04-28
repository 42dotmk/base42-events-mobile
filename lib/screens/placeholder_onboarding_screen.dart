import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class PlaceholderOnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const PlaceholderOnboardingScreen({super.key, required this.onComplete});

  @override
  State<PlaceholderOnboardingScreen> createState() =>
      _PlaceholderOnboardingScreenState();
}

class _PlaceholderOnboardingScreenState
    extends State<PlaceholderOnboardingScreen> {
  final PageController _controller = PageController();
  static const int _totalPages = 4;
  int _currentPage = 0;

  void _next() {
    if (_currentPage == _totalPages - 1) {
      widget.onComplete();
      return;
    }

    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
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
    final isLast = _currentPage == _totalPages - 1;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  children: const [
                    _PlaceholderPage(
                      title: 'Welcome to Base42',
                      subtitle:
                          'New onboarding design placeholder.\nScreen 1 of 4.',
                      icon: Icons.rocket_launch_outlined,
                    ),
                    _PlaceholderPage(
                      title: 'How Base42 Works',
                      subtitle:
                          'New onboarding design placeholder.\nScreen 2 of 4.',
                      icon: Icons.hub_outlined,
                    ),
                    _PlaceholderPage(
                      title: 'Community Guidelines',
                      subtitle:
                          'New onboarding design placeholder.\nScreen 3 of 4.',
                      icon: Icons.rule_rounded,
                    ),
                    _PlaceholderPage(
                      title: 'You Are Ready',
                      subtitle:
                          'New onboarding design placeholder.\nScreen 4 of 4.',
                      icon: Icons.verified_outlined,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
                child: Row(
                  children: [
                    Row(
                      children: List.generate(
                        _totalPages,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: index == _currentPage ? 18 : 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: index == _currentPage
                                ? colorScheme.primary
                                : colorScheme.onSurface.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: _next,
                      icon: Icon(
                        isLast
                            ? Icons.check_circle_outline_rounded
                            : Icons.arrow_forward_rounded,
                      ),
                      label: Text(isLast ? 'Done' : 'Next'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _PlaceholderPage({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, size: 32, color: colorScheme.primary),
          ),
          const SizedBox(height: 22),
          Text(
            title,
            style: context.textStyles.headlineMedium?.semiBold.withColor(
              colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: context.textStyles.titleMedium?.withColor(
              colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.55,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              'Temporary content. The final onboarding design will replace '
              'this section.',
              style: context.textStyles.bodyMedium?.withColor(
                colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
