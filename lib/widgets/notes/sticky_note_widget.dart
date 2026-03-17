import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/sticky_note.dart';

class StickyNoteWidget extends StatelessWidget {
  final StickyNote note;
  final double width;
  final double height;
  final bool isCompact;

  const StickyNoteWidget({
    super.key,
    required this.note,
    required this.width,
    required this.height,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: note.rotationAngle,
      child: _StickyBody(
        note: note,
        width: width,
        height: height,
        isCompact: isCompact,
      ),
    );
  }
}

class _StickyBody extends StatelessWidget {
  final StickyNote note;
  final double width;
  final double height;
  final bool isCompact;

  const _StickyBody({
    required this.note,
    required this.width,
    required this.height,
    required this.isCompact,
  });

  Color get _baseColor => note.color.color;
  Color get _shadowColor => note.color.shadowColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StickyPainter(baseColor: _baseColor, shadowColor: _shadowColor),
      child: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isCompact ? 2 : 5,
            isCompact ? 3 : 6,
            isCompact ? 2 : 4,
            isCompact ? 2 : 4,
          ),
          child: Text(
            note.text,
            style:
                (isCompact
                        ? AppTextStyles.stickyNoteMini
                        : AppTextStyles.stickyNoteMain)
                    .copyWith(
                      // ← isBold et isItalic appliqués ici
                      fontWeight: note.isBold
                          ? FontWeight.w800
                          : FontWeight.w400,
                      fontStyle: note.isItalic
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
            maxLines: isCompact ? 2 : 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _StickyPainter extends CustomPainter {
  final Color baseColor;
  final Color shadowColor;

  const _StickyPainter({required this.baseColor, required this.shadowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = AppDimensions.stickyCornerRadius;
    final foldSize = w * 0.22;

    // ── 1. Ombre portée ──────────────────────────────────────────────
    final shadowPaint = Paint()
      ..color = shadowColor.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(2, 3, w, h), Radius.circular(r)),
      shadowPaint,
    );

    // ── 2. Corps principal ───────────────────────────────────────────
    final bodyPath = Path()
      ..moveTo(foldSize, 0)
      ..lineTo(w - r, 0)
      ..arcToPoint(Offset(w, r), radius: Radius.circular(r))
      ..lineTo(w, h - r)
      ..arcToPoint(Offset(w - r, h), radius: Radius.circular(r))
      ..lineTo(r, h)
      ..arcToPoint(Offset(0, h - r), radius: Radius.circular(r))
      ..lineTo(0, foldSize)
      ..close();

    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          baseColor,
          baseColor.withValues(alpha: 0.88),
          Color.lerp(baseColor, Colors.white, 0.15)!,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(bodyPath, bodyPaint);

    // ── 3. Coin replié ───────────────────────────────────────────────
    final foldPath = Path()
      ..moveTo(0, foldSize)
      ..lineTo(foldSize, 0)
      ..lineTo(0, 0)
      ..close();

    final foldPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          shadowColor.withValues(alpha: 0.55),
          shadowColor.withValues(alpha: 0.25),
        ],
      ).createShader(Rect.fromLTWH(0, 0, foldSize, foldSize));

    canvas.drawPath(foldPath, foldPaint);

    final foldLinePaint = Paint()
      ..color = shadowColor.withValues(alpha: 0.4)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, foldSize), Offset(foldSize, 0), foldLinePaint);

    // ── 4. Reflet ────────────────────────────────────────────────────
    final glossPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white.withValues(alpha: 0.30), Colors.transparent],
      ).createShader(Rect.fromLTWH(foldSize, 0, w - foldSize, h * 0.4));

    canvas.drawPath(bodyPath, glossPaint);
  }

  @override
  bool shouldRepaint(covariant _StickyPainter old) =>
      old.baseColor != baseColor || old.shadowColor != shadowColor;
}
