import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// Le cadre en bois réaliste qui entoure tout le tableau.
/// Utilise plusieurs couches de dégradés et d'ombres pour
/// simuler le grain et la profondeur du bois.
class WoodBoard extends StatelessWidget {
  final Widget child;

  const WoodBoard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Ombre externe profonde (le tableau suspendu au mur)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.55),
            blurRadius: 28,
            spreadRadius: 4,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(3, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.woodCornerRadius + 2),
        child: CustomPaint(
          painter: _WoodFramePainter(),
          child: Padding(
            padding: EdgeInsets.all(
              AppDimensions.woodBorderWidth + AppDimensions.woodInnerPadding,
            ),
            child: _InnerBoard(child: child),
          ),
        ),
      ),
    );
  }
}

/// Fond ivoire intérieur du tableau avec léger bruit de texture
class _InnerBoard extends StatelessWidget {
  final Widget child;
  const _InnerBoard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.boardWhite,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          // Ombre interne (enfoncement dans le cadre)
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 6,
            spreadRadius: -2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Peint le cadre en bois avec grain, reflets et ombres internes
class _WoodFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final border = AppDimensions.woodBorderWidth + AppDimensions.woodInnerPadding;
    final radius = AppDimensions.woodCornerRadius;

    // ── 1. Fond de base bois foncé ──────────────────────────────────────
    final basePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.woodMedium,
          AppColors.woodDark,
          AppColors.woodMedium,
          AppColors.woodLight,
          AppColors.woodDark,
        ],
        stops: const [0.0, 0.2, 0.5, 0.75, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), Radius.circular(radius + 2)),
      basePaint,
    );

    // ── 2. Grain horizontal (lignes de bois) ────────────────────────────
    final grainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    final grainColors = [
      AppColors.woodHighlight.withOpacity(0.25),
      AppColors.woodShadow.withOpacity(0.15),
      AppColors.woodHighlight.withOpacity(0.18),
      AppColors.woodShadow.withOpacity(0.10),
    ];

    // Lignes horizontales simulant le fil du bois
    for (int i = 0; i < 60; i++) {
      final y = (h / 60) * i;
      grainPaint.color = grainColors[i % grainColors.length];
      // Légère ondulation pour simuler un vrai grain
      final path = Path();
      path.moveTo(0, y);
      for (double x = 0; x <= w; x += 20) {
        final wave = (i % 3 == 0) ? 1.2 : 0.5;
        path.lineTo(x + 10, y + wave);
        path.lineTo(x + 20, y);
      }
      canvas.drawPath(path, grainPaint);
    }

    // ── 3. Découpe intérieure (le "trou" du cadre) ───────────────────────
    final innerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(border, border, w - border * 2, h - border * 2),
      const Radius.circular(2),
    );

    // Ombre interne du cadre (profondeur)
    final innerShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.40)
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 8);
    canvas.drawRRect(innerRect, innerShadowPaint);

    // ── 4. Biseaux (chanfrein) sur les bords intérieurs du cadre ────────
    _drawBevel(canvas, size, border);

    // ── 5. Reflet en haut (lumière venant du haut) ───────────────────────
    final topGloss = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.22),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, border * 1.5));

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), Radius.circular(radius + 2)),
      topGloss,
    );
  }

  void _drawBevel(Canvas canvas, Size size, double border) {
    final w = size.width;
    final h = size.height;

    // Bord intérieur haut — clair (lumière)
    canvas.drawLine(
      Offset(border, border),
      Offset(w - border, border),
      Paint()
        ..color = AppColors.woodHighlight.withOpacity(0.5)
        ..strokeWidth = 1.2,
    );
    // Bord intérieur gauche — clair
    canvas.drawLine(
      Offset(border, border),
      Offset(border, h - border),
      Paint()
        ..color = AppColors.woodHighlight.withOpacity(0.4)
        ..strokeWidth = 1.0,
    );
    // Bord intérieur bas — sombre (ombre)
    canvas.drawLine(
      Offset(border, h - border),
      Offset(w - border, h - border),
      Paint()
        ..color = AppColors.woodShadow.withOpacity(0.6)
        ..strokeWidth = 1.2,
    );
    // Bord intérieur droit — sombre
    canvas.drawLine(
      Offset(w - border, border),
      Offset(w - border, h - border),
      Paint()
        ..color = AppColors.woodShadow.withOpacity(0.5)
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
