import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSpacing {
  // Spacing values
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Edge insets shortcuts
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  // Horizontal padding
  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  // Vertical padding
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);
}

/// Border radius constants for consistent rounded corners
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
}

/// Brand theme extension to carry non-ColorScheme brand tokens
@immutable
class BrandTheme extends ThemeExtension<BrandTheme> {
  final Color deepNavy; // #070B12
  final Color deepTeal; // #121E2C
  final Color neonCyan; // #7EF3F4
  final Color neonYellow; // #E9DF4A
  final Color linkTextGray; // muted gray for text links
  final Color successGreen; // success state color
  final Color errorRed; // error state color
  final Color quickActionDesk;
  final Color quickActionEvents;
  final Color quickActionCafe;
  final Color bookingStatusConfirmedText;
  final Color bookingStatusConfirmedBackground;
  final Color bookingStatusPendingText;
  final Color bookingStatusPendingBackground;
  final Color bookingStatusCompletedText;
  final Color bookingStatusCompletedBackground;
  final Color bookingStatusCancelledText;
  final Color bookingStatusCancelledBackground;

  const BrandTheme({
    required this.deepNavy,
    required this.deepTeal,
    required this.neonCyan,
    required this.neonYellow,
    required this.linkTextGray,
    required this.successGreen,
    required this.errorRed,
    required this.quickActionDesk,
    required this.quickActionEvents,
    required this.quickActionCafe,
    required this.bookingStatusConfirmedText,
    required this.bookingStatusConfirmedBackground,
    required this.bookingStatusPendingText,
    required this.bookingStatusPendingBackground,
    required this.bookingStatusCompletedText,
    required this.bookingStatusCompletedBackground,
    required this.bookingStatusCancelledText,
    required this.bookingStatusCancelledBackground,
  });

  LinearGradient get backdropGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      deepNavy,
      Color.alphaBlend(deepTeal.withValues(alpha: 0.85), deepNavy),
    ],
  );

  @override
  ThemeExtension<BrandTheme> copyWith({
    Color? deepNavy,
    Color? deepTeal,
    Color? neonCyan,
    Color? neonYellow,
    Color? linkTextGray,
    Color? successGreen,
    Color? errorRed,
    Color? quickActionDesk,
    Color? quickActionEvents,
    Color? quickActionCafe,
    Color? bookingStatusConfirmedText,
    Color? bookingStatusConfirmedBackground,
    Color? bookingStatusPendingText,
    Color? bookingStatusPendingBackground,
    Color? bookingStatusCompletedText,
    Color? bookingStatusCompletedBackground,
    Color? bookingStatusCancelledText,
    Color? bookingStatusCancelledBackground,
  }) => BrandTheme(
    deepNavy: deepNavy ?? this.deepNavy,
    deepTeal: deepTeal ?? this.deepTeal,
    neonCyan: neonCyan ?? this.neonCyan,
    neonYellow: neonYellow ?? this.neonYellow,
    linkTextGray: linkTextGray ?? this.linkTextGray,
    successGreen: successGreen ?? this.successGreen,
    errorRed: errorRed ?? this.errorRed,
    quickActionDesk: quickActionDesk ?? this.quickActionDesk,
    quickActionEvents: quickActionEvents ?? this.quickActionEvents,
    quickActionCafe: quickActionCafe ?? this.quickActionCafe,
    bookingStatusConfirmedText:
        bookingStatusConfirmedText ?? this.bookingStatusConfirmedText,
    bookingStatusConfirmedBackground:
        bookingStatusConfirmedBackground ??
        this.bookingStatusConfirmedBackground,
    bookingStatusPendingText:
        bookingStatusPendingText ?? this.bookingStatusPendingText,
    bookingStatusPendingBackground:
        bookingStatusPendingBackground ?? this.bookingStatusPendingBackground,
    bookingStatusCompletedText:
        bookingStatusCompletedText ?? this.bookingStatusCompletedText,
    bookingStatusCompletedBackground:
        bookingStatusCompletedBackground ??
        this.bookingStatusCompletedBackground,
    bookingStatusCancelledText:
        bookingStatusCancelledText ?? this.bookingStatusCancelledText,
    bookingStatusCancelledBackground:
        bookingStatusCancelledBackground ??
        this.bookingStatusCancelledBackground,
  );

  @override
  ThemeExtension<BrandTheme> lerp(ThemeExtension<BrandTheme>? other, double t) {
    if (other is! BrandTheme) return this;
    return BrandTheme(
      deepNavy: Color.lerp(deepNavy, other.deepNavy, t)!,
      deepTeal: Color.lerp(deepTeal, other.deepTeal, t)!,
      neonCyan: Color.lerp(neonCyan, other.neonCyan, t)!,
      neonYellow: Color.lerp(neonYellow, other.neonYellow, t)!,
      linkTextGray: Color.lerp(linkTextGray, other.linkTextGray, t)!,
      successGreen: Color.lerp(successGreen, other.successGreen, t)!,
      errorRed: Color.lerp(errorRed, other.errorRed, t)!,
      quickActionDesk: Color.lerp(quickActionDesk, other.quickActionDesk, t)!,
      quickActionEvents: Color.lerp(
        quickActionEvents,
        other.quickActionEvents,
        t,
      )!,
      quickActionCafe: Color.lerp(quickActionCafe, other.quickActionCafe, t)!,
      bookingStatusConfirmedText: Color.lerp(
        bookingStatusConfirmedText,
        other.bookingStatusConfirmedText,
        t,
      )!,
      bookingStatusConfirmedBackground: Color.lerp(
        bookingStatusConfirmedBackground,
        other.bookingStatusConfirmedBackground,
        t,
      )!,
      bookingStatusPendingText: Color.lerp(
        bookingStatusPendingText,
        other.bookingStatusPendingText,
        t,
      )!,
      bookingStatusPendingBackground: Color.lerp(
        bookingStatusPendingBackground,
        other.bookingStatusPendingBackground,
        t,
      )!,
      bookingStatusCompletedText: Color.lerp(
        bookingStatusCompletedText,
        other.bookingStatusCompletedText,
        t,
      )!,
      bookingStatusCompletedBackground: Color.lerp(
        bookingStatusCompletedBackground,
        other.bookingStatusCompletedBackground,
        t,
      )!,
      bookingStatusCancelledText: Color.lerp(
        bookingStatusCancelledText,
        other.bookingStatusCancelledText,
        t,
      )!,
      bookingStatusCancelledBackground: Color.lerp(
        bookingStatusCancelledBackground,
        other.bookingStatusCancelledBackground,
        t,
      )!,
    );
  }
}

// =============================================================================
// TEXT STYLE EXTENSIONS
// =============================================================================

/// Extension to add text style utilities to BuildContext
/// Access via context.textStyles
extension TextStyleContext on BuildContext {
  TextTheme get textStyles => Theme.of(this).textTheme;
}

/// Helper methods for common text style modifications
extension TextStyleExtensions on TextStyle {
  /// Make text bold
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  /// Make text semi-bold
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  /// Make text medium weight
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  /// Make text normal weight
  TextStyle get normal => copyWith(fontWeight: FontWeight.w400);

  /// Make text light
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  /// Add custom color
  TextStyle withColor(Color color) => copyWith(color: color);

  /// Add custom size
  TextStyle withSize(double size) => copyWith(fontSize: size);
}

// =============================================================================
// COLORS
// =============================================================================

/// Modern, neutral color palette for light mode
/// Uses soft grays and blues instead of purple for a contemporary look
class LightModeColors {
  // Primary/Secondary tuned to the new event UI accents.
  static const lightPrimary = Color(0xFF4CCDD1);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFFDBF5F6);
  static const lightOnPrimaryContainer = Color(0xFF11353A);

  // Secondary: Complementary gray-blue
  static const lightSecondary = Color(0xFFE9DF4A);
  static const lightOnSecondary = Color(0xFF1F2430);

  // Tertiary: Subtle accent color
  static const lightTertiary = Color(0xFF5A6E89);
  static const lightOnTertiary = Color(0xFFFFFFFF);

  // Error colors
  static const lightError = Color(0xFFBA1A1A);
  static const lightOnError = Color(0xFFFFFFFF);
  static const lightErrorContainer = Color(0xFFFFDAD6);
  static const lightOnErrorContainer = Color(0xFF410002);

  // Surface and background: High contrast for readability
  static const lightSurface = Color(0xFFF4F7FB);
  static const lightOnSurface = Color(0xFF121721);
  static const lightBackground = Color(0xFFEEF2F7);
  static const lightSurfaceVariant = Color(0xFFE0E8F1);
  static const lightOnSurfaceVariant = Color(0xFF4F5A69);

  // Outline and shadow
  static const lightOutline = Color(0xFF7B8594);
  static const lightShadow = Color(0xFF000000);
  static const lightInversePrimary = Color(0xFF7EF3F4);
}

/// Dark mode colors with good contrast
class DarkModeColors {
  // Primary accent: cyan used in headers and card top edge.
  static const darkPrimary = Color(0xFF7EF3F4);
  static const darkOnPrimary = Color(0xFF0D2A2E);
  static const darkPrimaryContainer = Color(0xFF16303C);
  static const darkOnPrimaryContainer = Color(0xFFC8FEFE);

  // Secondary
  static const darkSecondary = Color(0xFFE9DF4A);
  static const darkOnSecondary = Color(0xFF262817);

  // Tertiary
  static const darkTertiary = Color(0xFF86A6CE);
  static const darkOnTertiary = Color(0xFF1B2B40);

  // Error colors
  static const darkError = Color(0xFFFFB4AB);
  static const darkOnError = Color(0xFF690005);
  static const darkErrorContainer = Color(0xFF93000A);
  static const darkOnErrorContainer = Color(0xFFFFDAD6);

  // Surface and background: True dark mode
  static const darkSurface = Color(0xFF121A24);
  static const darkOnSurface = Color(0xFFF3F6FA);
  static const darkSurfaceVariant = Color(0xFF1A2431);
  static const darkOnSurfaceVariant = Color(0xFF98A5B5);

  // Outline and shadow
  static const darkOutline = Color(0xFF2D3B4B);
  static const darkShadow = Color(0xFF000000);
  static const darkInversePrimary = Color(0xFF4CCDD1);
}

/// Font size constants
class FontSizes {
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 28.0;
  static const double headlineSmall = 24.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 16.0;
  static const double titleSmall = 14.0;
  static const double labelLarge = 14.0;
  static const double labelMedium = 12.0;
  static const double labelSmall = 11.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
}

// =============================================================================
// THEMES
// =============================================================================

/// Light theme with modern aesthetic (kept neutral, minimal changes)
ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: LightModeColors.lightPrimary,
    onPrimary: LightModeColors.lightOnPrimary,
    primaryContainer: LightModeColors.lightPrimaryContainer,
    onPrimaryContainer: LightModeColors.lightOnPrimaryContainer,
    secondary: LightModeColors.lightSecondary,
    onSecondary: LightModeColors.lightOnSecondary,
    tertiary: LightModeColors.lightTertiary,
    onTertiary: LightModeColors.lightOnTertiary,
    error: LightModeColors.lightError,
    onError: LightModeColors.lightOnError,
    errorContainer: LightModeColors.lightErrorContainer,
    onErrorContainer: LightModeColors.lightOnErrorContainer,
    surface: LightModeColors.lightSurface,
    onSurface: LightModeColors.lightOnSurface,
    surfaceContainerHighest: LightModeColors.lightSurfaceVariant,
    onSurfaceVariant: LightModeColors.lightOnSurfaceVariant,
    outline: LightModeColors.lightOutline,
    shadow: LightModeColors.lightShadow,
    inversePrimary: LightModeColors.lightInversePrimary,
  ),
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF4F7FB),
  splashFactory: NoSplash.splashFactory,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: LightModeColors.lightOnSurface,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: LightModeColors.lightOutline.withValues(alpha: 0.2),
        width: 1,
      ),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      iconColor: LightModeColors.lightOnPrimary,
      foregroundColor: LightModeColors.lightOnPrimary,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: LightModeColors.lightSurfaceVariant,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: BorderSide(
        color: LightModeColors.lightOutline.withValues(alpha: 0.3),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: BorderSide(
        color: LightModeColors.lightOutline.withValues(alpha: 0.2),
      ),
    ),
  ),
  textTheme: _buildTextTheme(Brightness.light),
  extensions: const [
    BrandTheme(
      deepNavy: Color(0xFF070B12),
      deepTeal: Color(0xFF121E2C),
      neonCyan: Color(0xFF7EF3F4),
      neonYellow: Color(0xFFE9DF4A),
      linkTextGray: Color(0xFF9AA3B2),
      successGreen: Color(0xFF69D976),
      errorRed: Color(0xFFE27B7B),
      quickActionDesk: Color(0xFFE9DF4A),
      quickActionEvents: Color(0xFF7EF3F4),
      quickActionCafe: Color(0xFFE39A4B),
      bookingStatusConfirmedText: Color(0xFF6ADE77),
      bookingStatusConfirmedBackground: Color(0xFF2F7E46),
      bookingStatusPendingText: Color(0xFFEAB34B),
      bookingStatusPendingBackground: Color(0xFF6E5419),
      bookingStatusCompletedText: Color(0xFF9AA8BA),
      bookingStatusCompletedBackground: Color(0xFF33404F),
      bookingStatusCancelledText: Color(0xFFF16464),
      bookingStatusCancelledBackground: Color(0xFF6A2A2A),
    ),
  ],
);

/// Dark theme with good contrast and readability
ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: DarkModeColors.darkPrimary,
    onPrimary: DarkModeColors.darkOnPrimary,
    secondary: DarkModeColors.darkSecondary,
    onSecondary: DarkModeColors.darkOnSecondary,
    tertiary: DarkModeColors.darkTertiary,
    onTertiary: DarkModeColors.darkOnTertiary,
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    surface: DarkModeColors.darkSurface,
    onSurface: DarkModeColors.darkOnSurface,
    surfaceContainerHighest: DarkModeColors.darkSurfaceVariant,
    onSurfaceVariant: DarkModeColors.darkOnSurfaceVariant,
    outline: DarkModeColors.darkOutline,
    shadow: Colors.black,
    primaryContainer: DarkModeColors.darkPrimaryContainer,
    onPrimaryContainer: DarkModeColors.darkOnPrimaryContainer,
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    inversePrimary: DarkModeColors.darkInversePrimary,
    surfaceTint: DarkModeColors.darkPrimary,
  ),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF070B12),
  splashFactory: NoSplash.splashFactory,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: DarkModeColors.darkOutline.withValues(alpha: 0.45),
        width: 1,
      ),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      iconColor: Colors.black,
      foregroundColor: Colors.black,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1A2431),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: const BorderSide(color: Color(0xFF2D3B4B)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: BorderSide(
        color: const Color(0xFF2D3B4B).withValues(alpha: 0.7),
      ),
    ),
  ),
  textTheme: _buildTextTheme(Brightness.dark),
  extensions: const [
    BrandTheme(
      deepNavy: Color(0xFF070B12),
      deepTeal: Color(0xFF121E2C),
      neonCyan: Color(0xFF7EF3F4),
      neonYellow: Color(0xFFE9DF4A),
      linkTextGray: Color(0xFF9AA3B2),
      successGreen: Color(0xFF69D976),
      errorRed: Color(0xFFE27B7B),
      quickActionDesk: Color(0xFFE9DF4A),
      quickActionEvents: Color(0xFF7EF3F4),
      quickActionCafe: Color(0xFFE39A4B),
      bookingStatusConfirmedText: Color(0xFF6ADE77),
      bookingStatusConfirmedBackground: Color(0xFF2F7E46),
      bookingStatusPendingText: Color(0xFFEAB34B),
      bookingStatusPendingBackground: Color(0xFF6E5419),
      bookingStatusCompletedText: Color(0xFF9AA8BA),
      bookingStatusCompletedBackground: Color(0xFF33404F),
      bookingStatusCancelledText: Color(0xFFF16464),
      bookingStatusCancelledBackground: Color(0xFF6A2A2A),
    ),
  ],
);

/// Build text theme using Inter font family
TextTheme _buildTextTheme(Brightness brightness) {
  return TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: FontSizes.displayLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: FontSizes.displayMedium,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: FontSizes.displaySmall,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: FontSizes.headlineLarge,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: FontSizes.headlineMedium,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: FontSizes.headlineSmall,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: FontSizes.titleLarge,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: FontSizes.titleMedium,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: FontSizes.titleSmall,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: FontSizes.labelLarge,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: FontSizes.labelMedium,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: FontSizes.labelSmall,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: FontSizes.bodyLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: FontSizes.bodyMedium,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: FontSizes.bodySmall,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
  );
}
