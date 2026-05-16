import 'package:base42_events_mobile/l10n/app_strings.dart';
import 'package:base42_events_mobile/providers/settings_provider.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  final bool showSkip;
  final String? doneButtonLabel;

  const OnboardingScreen({
    super.key,
    required this.onComplete,
    this.showSkip = true,
    this.doneButtonLabel,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;
  static const _totalPages = 4;

  void _next() {
    if (_currentPage == _totalPages - 1) {
      widget.onComplete();
      return;
    }

    _controller.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
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
    final s = AppStrings.of(context);
    final isLast = _currentPage == _totalPages - 1;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            children: const [
              _Page1Arrival(),
              _Page2Philosophy(),
              _Page3Rules(),
              _Page4BoardingPass(),
            ],
          ),

          // Top bar: lang toggle (left) + skip (right)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _LangToggle(),
                  if (widget.showSkip && !isLast)
                    TextButton(
                      onPressed: widget.onComplete,
                      child: Text(
                        s.obSkip,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.38),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 72),
                ],
              ),
            ),
          ),

          // Bottom: dots + action button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomBar(
              currentPage: _currentPage,
              totalPages: _totalPages,
              isLast: isLast,
              onNext: _next,
              doneButtonLabel: widget.doneButtonLabel,
              brand: brand,
            ),
          ),
        ],
      ),
    );
  }
}

class _LangToggle extends StatelessWidget {
  const _LangToggle();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final brand = Theme.of(context).extension<BrandTheme>();
    final cyan = brand?.neonCyan ?? Theme.of(context).colorScheme.primary;
    final isMk = settings.locale == 'mk';

    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LangOption(
            label: 'МК',
            active: isMk,
            cyan: cyan,
            onTap: () => settings.setLocale('mk'),
          ),
          _LangOption(
            label: 'EN',
            active: !isMk,
            cyan: cyan,
            onTap: () => settings.setLocale('en'),
          ),
        ],
      ),
    );
  }
}

class _LangOption extends StatelessWidget {
  final String label;
  final bool active;
  final Color cyan;
  final VoidCallback onTap;

  const _LangOption({
    required this.label,
    required this.active,
    required this.cyan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? cyan.withValues(alpha: 0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? cyan.withValues(alpha: 0.5) : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? cyan : Colors.white.withValues(alpha: 0.35),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool isLast;
  final VoidCallback onNext;
  final String? doneButtonLabel;
  final BrandTheme? brand;

  const _BottomBar({
    required this.currentPage,
    required this.totalPages,
    required this.isLast,
    required this.onNext,
    required this.doneButtonLabel,
    required this.brand,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cyan = brand?.neonCyan ?? colorScheme.primary;
    final yellow = brand?.neonYellow ?? colorScheme.secondary;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            (brand?.deepNavy ?? const Color(0xFF070B12)).withValues(
              alpha: 0.98,
            ),
          ],
          stops: const [0.0, 0.36],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 48),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Dots
            Row(
              children: List.generate(totalPages, (i) {
                final active = i == currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.only(right: 6),
                  width: active ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? cyan : Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: cyan.withValues(alpha: 0.5),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                );
              }),
            ),
            const Spacer(),
            // Action button
            GestureDetector(
              onTap: onNext,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: isLast
                    ? const EdgeInsets.symmetric(horizontal: 24, vertical: 15)
                    : const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: isLast ? yellow : cyan,
                  borderRadius: BorderRadius.circular(isLast ? 16 : 50),
                  boxShadow: [
                    BoxShadow(
                      color: (isLast ? yellow : cyan).withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: isLast
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            doneButtonLabel ??
                                AppStrings.of(context).obEnterButton,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.black,
                            size: 18,
                          ),
                        ],
                      )
                    : const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.black,
                        size: 22,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Page1Arrival extends StatelessWidget {
  const _Page1Arrival();

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final cyan = brand?.neonCyan ?? colorScheme.primary;
    final yellow = brand?.neonYellow ?? colorScheme.secondary;
    final s = AppStrings.of(context);

    return Container(
      decoration: BoxDecoration(gradient: brand?.backdropGradient),
      child: Stack(
        children: [
          const Positioned.fill(child: _Starfield()),
          Positioned(
            top: -80,
            right: -60,
            child: _GlowOrb(color: cyan, size: 220),
          ),
          Positioned(
            bottom: 120,
            left: -80,
            child: _GlowOrb(color: yellow, size: 160),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 60, 28, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _WarningBadge(text: s.ob1Badge),
                  const SizedBox(height: 28),
                  Text(
                    s.ob1Title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s.ob1Subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _NeonDivider(color: cyan),
                  const SizedBox(height: 24),
                  _StoryBlock(emoji: '🌍', text: s.ob1Block1),
                  const SizedBox(height: 16),
                  _LocationCard(
                    cyan: cyan,
                    title: s.ob1LocationTitle,
                    subtitle: s.ob1LocationSub,
                  ),
                  const SizedBox(height: 20),
                  _NeonDivider(color: cyan),
                  const SizedBox(height: 20),
                  _StoryBlock(emoji: '🤓', text: s.ob1Block2),
                  const SizedBox(height: 20),
                  _NeonDivider(color: cyan),
                  const SizedBox(height: 20),
                  _StoryBlock(emoji: '🧠', text: s.ob1Block3),
                  const SizedBox(height: 20),
                  _NeonDivider(color: cyan),
                  const SizedBox(height: 20),
                  _StoryBlock(emoji: '👽', text: s.ob1Block4),
                  const SizedBox(height: 20),
                  _NeonDivider(color: cyan),
                  const SizedBox(height: 20),
                  _StoryBlock(emoji: '🤝', text: s.ob1Block5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Page2Philosophy extends StatelessWidget {
  const _Page2Philosophy();

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final cyan = brand?.neonCyan ?? colorScheme.primary;
    final yellow = brand?.neonYellow ?? colorScheme.secondary;
    final s = AppStrings.of(context);

    return Container(
      decoration: BoxDecoration(gradient: brand?.backdropGradient),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            left: -40,
            child: _GlowOrb(color: cyan, size: 180),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 56, 24, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PageLabel(text: s.ob2Label, color: cyan),
                  const SizedBox(height: 12),
                  Text(
                    s.ob2Title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _PhilosophyCard(
                    icon: Icons.hub_outlined,
                    iconColor: cyan,
                    title: s.ob2Card1Title,
                    body: s.ob2Card1Body,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 16),
                  _PhilosophyCard(
                    icon: Icons.memory_rounded,
                    iconColor: yellow,
                    title: s.ob2Card2Title,
                    body: s.ob2Card2Body,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Page3Rules extends StatelessWidget {
  const _Page3Rules();

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final cyan = brand?.neonCyan ?? colorScheme.primary;
    final yellow = brand?.neonYellow ?? colorScheme.secondary;
    final s = AppStrings.of(context);
    final rules = s.ob3Rules;

    return Container(
      decoration: BoxDecoration(gradient: brand?.backdropGradient),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 56, 24, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PageLabel(text: s.ob3Label, color: cyan),
                    const SizedBox(height: 12),
                    Text(
                      s.ob3Title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _CountBadge(
                      text: s.ob3RulesCount(rules.length),
                      color: yellow,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 140),
              sliver: SliverList.separated(
                itemCount: rules.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) => _RuleItem(
                  number: s.ob3RuleNumbers[i],
                  text: rules[i],
                  cyan: cyan,
                  yellow: yellow,
                  colorScheme: colorScheme,
                  isFirst: i == 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Page4BoardingPass extends StatelessWidget {
  const _Page4BoardingPass();

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final cyan = brand?.neonCyan ?? colorScheme.primary;
    final yellow = brand?.neonYellow ?? colorScheme.secondary;
    final s = AppStrings.of(context);

    return Container(
      decoration: BoxDecoration(gradient: brand?.backdropGradient),
      child: Stack(
        children: [
          const Positioned.fill(child: _Starfield()),
          Positioned(
            top: -40,
            right: -60,
            child: _GlowOrb(color: cyan, size: 240),
          ),
          Positioned(
            bottom: 100,
            left: -60,
            child: _GlowOrb(color: yellow, size: 180),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 60, 28, 160),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.ob4Title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s.ob4Subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.48),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  _BoardingPassCard(
                    s: s,
                    cyan: cyan,
                    yellow: yellow,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoardingPassCard extends StatelessWidget {
  final AppStrings s;
  final Color cyan;
  final Color yellow;
  final ColorScheme colorScheme;

  const _BoardingPassCard({
    required this.s,
    required this.cyan,
    required this.yellow,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cyan.withValues(alpha: 0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: cyan.withValues(alpha: 0.12),
            blurRadius: 32,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.memory_rounded, color: cyan, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'BASE42',
                      style: TextStyle(
                        color: cyan,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                Text(
                  s.ob4PassHeader,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // ── Thin divider ──
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  cyan.withValues(alpha: 0.6),
                  cyan.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),

          // ── ACCESS GRANTED badge ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: cyan.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cyan.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_rounded, color: cyan, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    s.ob4AccessGranted,
                    style: TextStyle(
                      color: cyan,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Fields ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              children: [
                _PassField(
                  label: s.ob4StatusLabel,
                  value: s.ob4StatusValue,
                  valueColor: yellow,
                ),
                _PassField(
                  label: s.ob4LevelLabel,
                  value: s.ob4LevelValue,
                  valueColor: cyan,
                  valueFontSize: 22,
                ),
                _PassField(
                  label: s.ob4AccessLabel,
                  value: s.ob4AccessValue,
                  valueColor: const Color(0xFF69D976),
                ),
              ],
            ),
          ),

          // ── Tear-off line ──
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: _TearOffDivider(),
          ),

          // ── Location footer ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                _PassFooterRow(
                  label: s.ob4LocationLabel,
                  value: s.ob4LocationValue,
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 10),
                _PassFooterRow(
                  label: s.ob4GalaxyLabel,
                  value: s.ob4GalaxyValue,
                  icon: Icons.public_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PassField extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final double valueFontSize;

  const _PassField({
    required this.label,
    required this.value,
    required this.valueColor,
    this.valueFontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: valueFontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: valueFontSize > 16 ? 1 : 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _PassFooterRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _PassFooterRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.3)),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.3),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _TearOffDivider extends StatelessWidget {
  const _TearOffDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left notch
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: BoxShape.circle,
          ),
        ),
        // Dashed line
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const dashWidth = 6.0;
              const dashGap = 5.0;
              final count = (constraints.maxWidth / (dashWidth + dashGap))
                  .floor();
              return Row(
                children: List.generate(
                  count,
                  (_) => Container(
                    width: dashWidth,
                    height: 1,
                    margin: const EdgeInsets.only(right: dashGap),
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
              );
            },
          ),
        ),
        // Right notch
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

class _PhilosophyCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final ColorScheme colorScheme;

  const _PhilosophyCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: iconColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            body,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.58),
              fontSize: 13.5,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  final int number;
  final String text;
  final Color cyan;
  final Color yellow;
  final ColorScheme colorScheme;
  final bool isFirst;

  const _RuleItem({
    required this.number,
    required this.text,
    required this.cyan,
    required this.yellow,
    required this.colorScheme,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isFirst ? yellow : cyan;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: isFirst
            ? yellow.withValues(alpha: 0.08)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFirst
              ? yellow.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '$number.',
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.w700,
                fontSize: isFirst ? 15 : 13,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isFirst
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.72),
                fontSize: isFirst ? 15 : 13.5,
                fontWeight: isFirst ? FontWeight.w700 : FontWeight.w400,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningBadge extends StatelessWidget {
  final String text;
  const _WarningBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFFFD700).withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final String text;
  final Color color;
  const _CountBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final Color cyan;
  final String title;
  final String subtitle;
  const _LocationCard({
    required this.cyan,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cyan.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cyan.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Text('📍', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: cyan,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StoryBlock extends StatelessWidget {
  final String emoji;
  final String text;
  const _StoryBlock({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 14,
              height: 1.65,
            ),
          ),
        ),
      ],
    );
  }
}

class _PageLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _PageLabel({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color.withValues(alpha: 0.7),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
      ),
    );
  }
}

class _NeonDivider extends StatelessWidget {
  final Color color;
  const _NeonDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(height: 1, width: 32, color: color.withValues(alpha: 0.6)),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.6),
                  color.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Decorative ───────────────────────────────────────────────────────────────

class _Starfield extends StatelessWidget {
  const _Starfield();

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _StarfieldPainter());
}

class _StarfieldPainter extends CustomPainter {
  static const _stars = [
    (0.08, 0.06, 1.2, 0.5),
    (0.15, 0.22, 0.8, 0.35),
    (0.72, 0.08, 1.5, 0.6),
    (0.55, 0.18, 1.0, 0.4),
    (0.88, 0.12, 1.8, 0.55),
    (0.25, 0.35, 0.6, 0.3),
    (0.92, 0.42, 1.2, 0.45),
    (0.04, 0.48, 0.9, 0.35),
    (0.45, 0.05, 1.4, 0.5),
    (0.63, 0.32, 0.7, 0.3),
    (0.78, 0.55, 1.6, 0.6),
    (0.12, 0.62, 1.0, 0.4),
    (0.33, 0.72, 0.8, 0.3),
    (0.58, 0.68, 1.3, 0.5),
    (0.82, 0.75, 1.1, 0.45),
    (0.20, 0.88, 0.7, 0.25),
    (0.70, 0.85, 1.5, 0.55),
    (0.40, 0.92, 0.9, 0.35),
    (0.95, 0.22, 1.2, 0.4),
    (0.50, 0.45, 0.6, 0.28),
    (0.36, 0.15, 1.8, 0.65),
    (0.60, 0.52, 0.8, 0.3),
    (0.02, 0.78, 1.4, 0.5),
    (0.85, 0.90, 1.0, 0.4),
    (0.48, 0.30, 0.7, 0.3),
    (0.17, 0.50, 1.2, 0.45),
    (0.90, 0.65, 0.9, 0.38),
    (0.28, 0.95, 1.6, 0.55),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final (x, y, r, a) in _stars) {
      paint.color = Colors.white.withValues(alpha: a * 0.8);
      canvas.drawCircle(Offset(x * size.width, y * size.height), r, paint);
    }
  }

  @override
  bool shouldRepaint(_StarfieldPainter old) => false;
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.12), color.withValues(alpha: 0.0)],
        ),
      ),
    );
  }
}
