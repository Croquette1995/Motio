import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Palette Bauhaus Pastel ---
// Fond clair / craie, encre ardoise neutre et déclinaisons pastel des primaires (bleu, jaune, rouge/corail) + vert validation.
const chalk = Color(0xFFF7F8FA); // Blanc cassé / craie
const cardSurface = Color(0xFFFFFFFF);
const slate = Color(0xFF1E242B); // Noir d'encre Bauhaus adouci
const pastelBlue = Color(0xFF7BA4D5); // Bleu primaire adouci (grammaire / focus)
const pastelRed = Color(0xFFE98877); // Rouge primaire adouci (accent / révision)
const pastelYellow = Color(0xFFF6CC70); // Jaune primaire adouci (XP / points clés)
const pastelMint = Color(0xFF8DCBB5); // Vert validation (succès d'exercice)
const lineGrey = Color(0xFFE2E5EA);

// --- Tokens d'extension de thème ---
class BauhausColors extends ThemeExtension<BauhausColors> {
  const BauhausColors({
    required this.chalk,
    required this.cardSurface,
    required this.slate,
    required this.pastelBlue,
    required this.pastelRed,
    required this.pastelYellow,
    required this.pastelMint,
    required this.lineGrey,
  });

  final Color chalk;
  final Color cardSurface;
  final Color slate;
  final Color pastelBlue;
  final Color pastelRed;
  final Color pastelYellow;
  final Color pastelMint;
  final Color lineGrey;

  @override
  BauhausColors copyWith({
    Color? chalk,
    Color? cardSurface,
    Color? slate,
    Color? pastelBlue,
    Color? pastelRed,
    Color? pastelYellow,
    Color? pastelMint,
    Color? lineGrey,
  }) =>
      BauhausColors(
        chalk: chalk ?? this.chalk,
        cardSurface: cardSurface ?? this.cardSurface,
        slate: slate ?? this.slate,
        pastelBlue: pastelBlue ?? this.pastelBlue,
        pastelRed: pastelRed ?? this.pastelRed,
        pastelYellow: pastelYellow ?? this.pastelYellow,
        pastelMint: pastelMint ?? this.pastelMint,
        lineGrey: lineGrey ?? this.lineGrey,
      );

  @override
  BauhausColors lerp(BauhausColors? other, double t) {
    if (other == null) return this;
    return BauhausColors(
      chalk: Color.lerp(chalk, other.chalk, t)!,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      slate: Color.lerp(slate, other.slate, t)!,
      pastelBlue: Color.lerp(pastelBlue, other.pastelBlue, t)!,
      pastelRed: Color.lerp(pastelRed, other.pastelRed, t)!,
      pastelYellow: Color.lerp(pastelYellow, other.pastelYellow, t)!,
      pastelMint: Color.lerp(pastelMint, other.pastelMint, t)!,
      lineGrey: Color.lerp(lineGrey, other.lineGrey, t)!,
    );
  }
}

// Extension pratique sur BuildContext
extension BauhausContextX on BuildContext {
  BauhausColors get bauhaus =>
      Theme.of(this).extension<BauhausColors>() ??
      const BauhausColors(
        chalk: chalk,
        cardSurface: cardSurface,
        slate: slate,
        pastelBlue: pastelBlue,
        pastelRed: pastelRed,
        pastelYellow: pastelYellow,
        pastelMint: pastelMint,
        lineGrey: lineGrey,
      );
}

// --- Forme Bauhaus adoucie : rayon géométrique contenu (8-12px) et filet net ---
RoundedRectangleBorder bauhausBorder({
  double radius = 10.0,
  Color color = slate,
  double width = 1.5,
}) =>
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(color: color, width: width),
    );

// --- Curseur Slider géométrique (cercle double épuré) ---
class BauhausCircleThumb extends SliderComponentShape {
  const BauhausCircleThumb({this.radius = 9.0});
  final double radius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(radius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    // Disque extérieur
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = cardSurface,
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = sliderTheme.thumbColor ?? slate,
    );
    // Point focal central géométrique
    canvas.drawCircle(
      center,
      3.5,
      Paint()..color = sliderTheme.thumbColor ?? slate,
    );
  }
}

// --- Filet Bauhaus : ponctuation géométrique nette ---
class BauhausRule extends StatelessWidget {
  const BauhausRule({super.key});

  @override
  Widget build(BuildContext context) {
    final b = context.bauhaus;
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: b.pastelRed,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: b.pastelBlue,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(height: 1.5, color: b.lineGrey),
        ),
      ],
    );
  }
}

// --- Barre d'avancement par blocs géométriques modulaires ---
class BauhausProgress extends StatelessWidget {
  const BauhausProgress({
    super.key,
    required this.done,
    required this.total,
    this.height = 8.0,
    this.activeColor,
    this.currentColor,
  });

  final int done;
  final int total;
  final double height;
  final Color? activeColor;
  final Color? currentColor;

  @override
  Widget build(BuildContext context) {
    final b = context.bauhaus;
    final effectiveTotal = total > 0 ? total : 1;
    final fill = activeColor ?? b.pastelBlue;
    final currentFill = currentColor ?? b.pastelYellow;

    return Row(
      children: List.generate(effectiveTotal, (i) {
        final isFilled = i < done;
        final isCurrent = i == done && done < effectiveTotal;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i == effectiveTotal - 1 ? 0 : 5),
            height: height,
            decoration: BoxDecoration(
              color: isFilled
                  ? fill
                  : (isCurrent ? currentFill : b.cardSurface),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: b.slate, width: 1.2),
            ),
          ),
        );
      }),
    );
  }
}

// --- Thème Bauhaus Pastel complet ---
ThemeData bauhausTheme({bool isDark = false}) {
  final base = isDark
      ? ThemeData.dark(useMaterial3: true)
      : ThemeData.light(useMaterial3: true);

  // Typographie : géométrique pure sans-serif (Jost, dérivée directe de Futura)
  final text = GoogleFonts.jostTextTheme(base.textTheme).apply(
    bodyColor: slate,
    displayColor: slate,
  );

  const defaultBorderRadius = BorderRadius.all(Radius.circular(10));
  const defaultLine = BorderSide(color: slate, width: 1.5);

  return base.copyWith(
    extensions: const [
      BauhausColors(
        chalk: chalk,
        cardSurface: cardSurface,
        slate: slate,
        pastelBlue: pastelBlue,
        pastelRed: pastelRed,
        pastelYellow: pastelYellow,
        pastelMint: pastelMint,
        lineGrey: lineGrey,
      ),
    ],
    colorScheme: const ColorScheme.light(
      primary: slate,
      onPrimary: cardSurface,
      secondary: pastelBlue,
      onSecondary: slate,
      tertiary: pastelYellow,
      surface: cardSurface,
      onSurface: slate,
      outline: slate,
      outlineVariant: lineGrey,
      error: pastelRed,
    ),
    scaffoldBackgroundColor: chalk,
    textTheme: text.copyWith(
      headlineMedium: text.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineSmall: text.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      titleLarge: text.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      labelLarge: text.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      backgroundColor: chalk,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: text.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: slate,
      ),
      iconTheme: const IconThemeData(color: slate),
    ),
    cardTheme: CardThemeData(
      color: cardSurface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: bauhausBorder(radius: 12),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: slate,
        foregroundColor: cardSurface,
        elevation: 0,
        shape: bauhausBorder(radius: 8, color: slate),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: slate,
        backgroundColor: cardSurface,
        elevation: 0,
        side: defaultLine,
        shape: bauhausBorder(radius: 8, color: slate),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: const OutlineInputBorder(
        borderRadius: defaultBorderRadius,
        borderSide: defaultLine,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: defaultBorderRadius,
        borderSide: defaultLine,
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: defaultBorderRadius,
        borderSide: BorderSide(color: pastelBlue, width: 2),
      ),
      labelStyle: text.bodyMedium?.copyWith(color: slate.withValues(alpha: 0.6)),
      floatingLabelStyle: text.bodySmall?.copyWith(
        color: slate,
        fontWeight: FontWeight.w700,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: const BorderSide(color: slate, width: 1.5),
      fillColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? slate : Colors.transparent,
      ),
      checkColor: const WidgetStatePropertyAll(cardSurface),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? pastelBlue : cardSurface,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(slate),
      trackOutlineWidth: const WidgetStatePropertyAll(1.5),
      thumbColor: const WidgetStatePropertyAll(slate),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    sliderTheme: SliderThemeData(
      trackHeight: 3,
      activeTrackColor: slate,
      inactiveTrackColor: lineGrey,
      thumbColor: slate,
      overlayColor: Colors.transparent,
      thumbShape: const BauhausCircleThumb(),
      trackShape: const RectangularSliderTrackShape(),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: cardSurface,
      selectedColor: pastelYellow,
      disabledColor: chalk,
      side: const BorderSide(color: slate, width: 1.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      labelStyle: text.labelSmall?.copyWith(
        color: slate,
        fontWeight: FontWeight.w600,
      ),
      secondaryLabelStyle: text.labelSmall?.copyWith(
        color: slate,
        fontWeight: FontWeight.w700,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      elevation: 0,
      pressElevation: 0,
    ),
    dividerTheme: const DividerThemeData(
      color: lineGrey,
      thickness: 1.5,
      space: 24,
    ),
  );
}
