import 'package:base42_events_mobile/consts/rules.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/common/page_header.dart';
import 'package:base42_events_mobile/widgets/onboarding/onboarding_action_button.dart';
import 'package:base42_events_mobile/widgets/onboarding/onboarding_dots.dart';
import 'package:flutter/material.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _next() {
    if (_currentPage == houseRules.length - 1) {
      Navigator.of(context).maybePop();
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
    final isLast = _currentPage == houseRules.length - 1;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SafeArea(
          child: Column(
            children: [
              PageHeader(
                title: 'House Rules',
                onBack: () => Navigator.of(context).maybePop(),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: houseRules.length,
                  itemBuilder: (context, index) {
                    final rule = houseRules[index];
                    return Padding(
                      padding: AppSpacing.horizontalLg,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Image.asset(
                                rule.imageAssetPath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: colorScheme.surfaceContainerHighest,
                                  child: Center(
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                      size: 48,
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          Text(
                            rule.title,
                            style: context.textStyles.headlineLarge?.semiBold
                                .withColor(colorScheme.onSurface),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            rule.description,
                            style: context.textStyles.bodyLarge?.withColor(
                              colorScheme.onSurface.withValues(alpha: 0.72),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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
                        totalPages: houseRules.length,
                      ),
                      const Spacer(),
                      OnboardingActionButton(
                        isLast: isLast,
                        onPressed: _next,
                        doneButtonLabel: 'Got it',
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
