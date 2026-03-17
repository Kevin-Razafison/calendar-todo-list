import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class WoodBoard extends StatelessWidget {
  final Widget child;
  const WoodBoard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.65),
            blurRadius: 32,
            spreadRadius: 6,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 10,
            offset: const Offset(4, 5),
          ),
        ],
      ),
      child: Listener(
        onPointerDown: (event) {
          print('🪵 WoodBoard pointer down');
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            AppDimensions.woodCornerRadius + 2,
          ),
          child: Stack(
            children: [
              // ── 1. Vraie texture bois (image JPG) ──────────────────────
              Positioned.fill(
                child: Image.asset(
                  'assets/textures/wood_texture.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              // ── 2. Overlay vernis (brillance légère) ───────────────────
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.08),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.12),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // ── 3. Ombre interne (profondeur du cadre) ──────────────────
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.55),
                          blurRadius: 16,
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── 4. Contenu (tableau blanc intérieur) ────────────────────
              Padding(
                padding: EdgeInsets.all(
                  AppDimensions.woodBorderWidth +
                      AppDimensions.woodInnerPadding,
                ),
                child: _InnerBoard(child: child),
              ),

              // ── 5. Biseaux intérieurs (chanfrein réaliste) ──────────────
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _BevelPainter()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InnerBoard extends StatelessWidget {
  final Widget child;
  const _InnerBoard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            spreadRadius: -1,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Listener(
        onPointerDown: (event) {
          print('📦 _InnerBoard pointer down');
        },
        child: child,
      ),
    );
  }
}

/// Dessine uniquement les biseaux intérieurs du cadre
class _BevelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final border =
        AppDimensions.woodBorderWidth + AppDimensions.woodInnerPadding;
    final w = size.width;
    final h = size.height;

    // Bord intérieur haut — clair
    canvas.drawLine(
      Offset(border, border),
      Offset(w - border, border),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.30)
        ..strokeWidth = 1.5,
    );
    // Bord intérieur gauche — clair
    canvas.drawLine(
      Offset(border, border),
      Offset(border, h - border),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.20)
        ..strokeWidth = 1.2,
    );
    // Bord intérieur bas — sombre
    canvas.drawLine(
      Offset(border, h - border),
      Offset(w - border, h - border),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.45)
        ..strokeWidth = 1.5,
    );
    // Bord intérieur droit — sombre
    canvas.drawLine(
      Offset(w - border, border),
      Offset(w - border, h - border),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.35)
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
