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
  final Color deepNavy; // #082428
  final Color deepTeal; // #05474D
  final Color neonCyan; // #2BEDED
  final Color neonYellow; // #FAE127

  const BrandTheme({
    required this.deepNavy,
    required this.deepTeal,
    required this.neonCyan,
    required this.neonYellow,
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
  }) => BrandTheme(
    deepNavy: deepNavy ?? this.deepNavy,
    deepTeal: deepTeal ?? this.deepTeal,
    neonCyan: neonCyan ?? this.neonCyan,
    neonYellow: neonYellow ?? this.neonYellow,
  );

  @override
  ThemeExtension<BrandTheme> lerp(ThemeExtension<BrandTheme>? other, double t) {
    if (other is! BrandTheme) return this;
    return BrandTheme(
      deepNavy: Color.lerp(deepNavy, other.deepNavy, t)!,
      deepTeal: Color.lerp(deepTeal, other.deepTeal, t)!,
      neonCyan: Color.lerp(neonCyan, other.neonCyan, t)!,
      neonYellow: Color.lerp(neonYellow, other.neonYellow, t)!,
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
  // Primary: Soft blue-gray for a modern, professional look
  static const lightPrimary = Color(0xFF5B7C99);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFFD8E6F3);
  static const lightOnPrimaryContainer = Color(0xFF1A3A52);

  // Secondary: Complementary gray-blue
  static const lightSecondary = Color(0xFF5C6B7A);
  static const lightOnSecondary = Color(0xFFFFFFFF);

  // Tertiary: Subtle accent color
  static const lightTertiary = Color(0xFF6B7C8C);
  static const lightOnTertiary = Color(0xFFFFFFFF);

  // Error colors
  static const lightError = Color(0xFFBA1A1A);
  static const lightOnError = Color(0xFFFFFFFF);
  static const lightErrorContainer = Color(0xFFFFDAD6);
  static const lightOnErrorContainer = Color(0xFF410002);

  // Surface and background: High contrast for readability
  static const lightSurface = Color(0xFFFBFCFD);
  static const lightOnSurface = Color(0xFF1A1C1E);
  static const lightBackground = Color(0xFFF7F9FA);
  static const lightSurfaceVariant = Color(0xFFE2E8F0);
  static const lightOnSurfaceVariant = Color(0xFF44474E);

  // Outline and shadow
  static const lightOutline = Color(0xFF74777F);
  static const lightShadow = Color(0xFF000000);
  static const lightInversePrimary = Color(0xFFACC7E3);
}

/// Dark mode colors with good contrast
class DarkModeColors {
  // Primary: Lighter blue for dark background
  static const darkPrimary = Color(0xFFACC7E3);
  static const darkOnPrimary = Color(0xFF1A3A52);
  static const darkPrimaryContainer = Color(0xFF3D5A73);
  static const darkOnPrimaryContainer = Color(0xFFD8E6F3);

  // Secondary
  static const darkSecondary = Color(0xFFBCC7D6);
  static const darkOnSecondary = Color(0xFF2E3842);

  // Tertiary
  static const darkTertiary = Color(0xFFB8C8D8);
  static const darkOnTertiary = Color(0xFF344451);

  // Error colors
  static const darkError = Color(0xFFFFB4AB);
  static const darkOnError = Color(0xFF690005);
  static const darkErrorContainer = Color(0xFF93000A);
  static const darkOnErrorContainer = Color(0xFFFFDAD6);

  // Surface and background: True dark mode
  static const darkSurface = Color(0xFF1A1C1E);
  static const darkOnSurface = Color(0xFFE2E8F0);
  static const darkSurfaceVariant = Color(0xFF44474E);
  static const darkOnSurfaceVariant = Color(0xFFC4C7CF);

  // Outline and shadow
  static const darkOutline = Color(0xFF8E9099);
  static const darkShadow = Color(0xFF000000);
  static const darkInversePrimary = Color(0xFF5B7C99);
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
  scaffoldBackgroundColor: LightModeColors.lightBackground,
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
      deepNavy: Color(0xFF082428),
      deepTeal: Color(0xFF05474D),
      neonCyan: Color(0xFF2BEDED),
      neonYellow: Color(0xFFFAE127),
    ),
  ],
);

/// Dark theme with good contrast and readability
ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF2BEDED),
    // neon cyan accents
    onPrimary: Color(0xFF042629),
    secondary: Color(0xFFFAE127),
    // neon yellow accents
    onSecondary: Color(0xFF082428),
    tertiary: Color(0xFF7CECEF),
    onTertiary: Colors.black,
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    surface: Color(0xFF0B2A2E),
    onSurface: Colors.white,
    surfaceContainerHighest: Color(0xFF124349),
    onSurfaceVariant: Color(0xFFB2CDD0),
    outline: Color(0xFF5A7A7D),
    shadow: Colors.black,
    primaryContainer: Color(0xFF0E373C),
    onPrimaryContainer: Color(0xFFB8FEFF),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    inversePrimary: Color(0xFF0FE1E6),
    surfaceTint: Color(0xFF2BEDED),
  ),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF082428),
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
        color: const Color(0xFF5A7A7D).withValues(alpha: 0.2),
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
    fillColor: const Color(0xFF0E373C),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: const BorderSide(color: Color(0xFF5A7A7D)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: BorderSide(
        color: const Color(0xFF5A7A7D).withValues(alpha: 0.4),
      ),
    ),
  ),
  textTheme: _buildTextTheme(Brightness.dark),
  extensions: const [
    BrandTheme(
      deepNavy: Color(0xFF082428),
      deepTeal: Color(0xFF05474D),
      neonCyan: Color(0xFF2BEDED),
      neonYellow: Color(0xFFFAE127),
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
