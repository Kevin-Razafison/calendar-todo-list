import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../models/month_data.dart';

class BoardLayout extends StatelessWidget {
  final List<MonthData> months;
  final int currentMonthIndex;
  final Widget Function(MonthData month, bool isCurrent) miniMonthBuilder;
  final Widget Function(MonthData month) mainMonthBuilder;
  final Widget quickNotesBar;

  const BoardLayout({
    super.key,
    required this.months,
    required this.currentMonthIndex,
    required this.miniMonthBuilder,
    required this.mainMonthBuilder,
    required this.quickNotesBar,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = AppDimensions.monthGap;
        final availableW = constraints.maxWidth;

        // Cases carrées
        final slotSize = availableW / 5;
        // Grande case titre = même hauteur que les slots
        const titleBarHeight = 40.0;
        const titleBarMargin = 4.0;
        final quickBarHeight = slotSize;

        final availableH =
            constraints.maxHeight -
            quickBarHeight -
            titleBarHeight -
            titleBarMargin;

        final cellW = (availableW - gap * 3) / 4;
        final cellH = (availableH - gap * 3) / 4;

        return Column(
          children: [
            // ── Grille des mois ────────────────────────────────────────
            SizedBox(
              width: availableW,
              height: availableH,
              child: Stack(
                children: [
                  _positioned(0, 0, cellW, cellH, gap, _miniCell(months[0])),
                  _positioned(1, 0, cellW, cellH, gap, _miniCell(months[1])),
                  _positioned(2, 0, cellW, cellH, gap, _miniCell(months[2])),
                  _positioned(3, 0, cellW, cellH, gap, _miniCell(months[3])),
                  _positioned(0, 1, cellW, cellH, gap, _miniCell(months[11])),
                  _positioned(0, 2, cellW, cellH, gap, _miniCell(months[10])),
                  _positioned(3, 1, cellW, cellH, gap, _miniCell(months[4])),
                  _positioned(3, 2, cellW, cellH, gap, _miniCell(months[5])),
                  _positioned(0, 3, cellW, cellH, gap, _miniCell(months[9])),
                  _positioned(1, 3, cellW, cellH, gap, _miniCell(months[8])),
                  _positioned(2, 3, cellW, cellH, gap, _miniCell(months[7])),
                  _positioned(3, 3, cellW, cellH, gap, _miniCell(months[6])),
                  Positioned(
                    left: cellW + gap,
                    top: cellH + gap,
                    width: cellW * 2 + gap,
                    height: cellH * 2 + gap,
                    child: _MainMonthCell(
                      child: mainMonthBuilder(months[currentMonthIndex]),
                    ),
                  ),
                ],
              ),
            ),

            // ── Grande case titre ───────────────────────────────────────
            SizedBox(height: titleBarMargin),
            _TitleBar(width: availableW, height: titleBarHeight),

            // ── 5 cases quick notes ─────────────────────────────────────
            SizedBox(height: quickBarHeight, child: quickNotesBar),
          ],
        );
      },
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _miniCell(MonthData month) {
    final isCurrent = month.month - 1 == currentMonthIndex;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.boardWhite,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 4,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: miniMonthBuilder(month, isCurrent),
    );
  }

  Widget _positioned(
    int col,
    int row,
    double cellW,
    double cellH,
    double gap,
    Widget child,
  ) {
    return Positioned(
      left: col * (cellW + gap),
      top: row * (cellH + gap),
      width: cellW,
      height: cellH,
      child: child,
    );
  }
}

class _MainMonthCell extends StatelessWidget {
  final Widget child;
  const _MainMonthCell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.mainMonthBg, // ← était boardWhite
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.7),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 1,
            spreadRadius: 2,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _TitleBar extends StatefulWidget {
  final double width;
  final double height;
  const _TitleBar({required this.width, required this.height});

  @override
  State<_TitleBar> createState() => _TitleBarState();
}

class _TitleBarState extends State<_TitleBar> {
  final _controller = TextEditingController();
  bool _editing = false;
  bool _showFormat = false;
  Color _bgColor = Colors.transparent;
  Color _textColor = AppColors.textDark;
  bool _bold = false;
  bool _italic = false;

  static const List<Color> _bgColors = [
    Colors.transparent,
    Color(0xFFFFF59D),
    Color(0xFFB9F6CA),
    Color(0xFFFFCDD2),
    Color(0xFFB3E5FC),
    Color(0xFFE1BEE7),
    Color(0xFFFFE0B2),
  ];

  static const List<Color> _textColors = [
    Color(0xFF1A1008),
    Color(0xFFC62828),
    Color(0xFF1565C0),
    Color(0xFF2E7D32),
    Color(0xFF6A1B9A),
    Color(0xFFE65100),
    Color(0xFF795548),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextStyle get _textStyle => TextStyle(
    fontFamily: 'Caveat',
    fontSize: 20,
    fontWeight: _bold ? FontWeight.w800 : FontWeight.w500,
    fontStyle: _italic ? FontStyle.italic : FontStyle.normal,
    color: _textColor,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // ← permet au panneau de dépasser vers le haut
      children: [
        // ── Barre principale ──────────────────────────────────────────
        GestureDetector(
          onTap: () => setState(() => _editing = true),
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: _bgColor == Colors.transparent
                  ? AppColors.stickyYellow.withValues(alpha: 0.08)
                  : _bgColor.withValues(alpha: 0.45),
              border: Border(
                top: BorderSide(
                  color: AppColors.woodMedium.withValues(alpha: 0.25),
                  width: 1,
                ),
                bottom: BorderSide(
                  color: AppColors.woodMedium.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _editing
                      ? TextField(
                          controller: _controller,
                          autofocus: true,
                          textAlign: TextAlign.center,
                          style: _textStyle,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Add a title...',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                          ),
                          onSubmitted: (_) => setState(() => _editing = false),
                          onTapOutside: (_) => setState(() => _editing = false),
                        )
                      : Center(
                          child: Text(
                            _controller.text.isEmpty
                                ? 'Tap to add a title...'
                                : _controller.text,
                            style: _controller.text.isEmpty
                                ? _textStyle.copyWith(
                                    color: AppColors.textLight.withValues(
                                      alpha: 0.4,
                                    ),
                                  )
                                : _textStyle,
                          ),
                        ),
                ),
                // Bouton format discret
                GestureDetector(
                  onTap: () => setState(() => _showFormat = !_showFormat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _showFormat
                          ? AppColors.woodMedium.withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColors.woodMedium.withValues(
                          alpha: _showFormat ? 0.3 : 0.15,
                        ),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.text_format,
                      size: 16,
                      color: AppColors.woodMedium.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Panneau formatage — flotte AU-DESSUS vers le haut ─────────
        if (_showFormat)
          Positioned(
            bottom: widget.height, // ← au-dessus de la barre
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.boardWhite,
                border: Border.all(
                  color: AppColors.woodMedium.withValues(alpha: 0.2),
                  width: 1,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ligne 1 : Bold / Italic + couleurs texte
                  Row(
                    children: [
                      _FormatButton(
                        label: 'B',
                        bold: true,
                        active: _bold,
                        onTap: () => setState(() => _bold = !_bold),
                      ),
                      const SizedBox(width: 6),
                      _FormatButton(
                        label: 'I',
                        italic: true,
                        active: _italic,
                        onTap: () => setState(() => _italic = !_italic),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 1,
                        height: 20,
                        color: AppColors.boardGrid,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'A',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      ..._textColors.map(
                        (c) => _ColorDot(
                          color: c,
                          isSelected: _textColor == c,
                          onTap: () => setState(() => _textColor = c),
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Ligne 2 : couleurs background
                  Row(
                    children: [
                      Text(
                        'BG',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      ..._bgColors.map(
                        (c) => _ColorDot(
                          color: c == Colors.transparent ? Colors.white : c,
                          isSelected: _bgColor == c,
                          onTap: () => setState(() => _bgColor = c),
                          size: 16,
                          showX: c == Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ── Widgets helpers ────────────────────────────────────────────────────────

class _FormatButton extends StatelessWidget {
  final String label;
  final bool bold;
  final bool italic;
  final bool active;
  final VoidCallback onTap;

  const _FormatButton({
    required this.label,
    this.bold = false,
    this.italic = false,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: active
              ? AppColors.woodMedium.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: AppColors.woodMedium.withValues(alpha: active ? 0.4 : 0.2),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w400,
              fontStyle: italic ? FontStyle.italic : FontStyle.normal,
              color: active ? AppColors.textDark : AppColors.textMedium,
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  final double size;
  final bool showX;

  const _ColorDot({
    required this.color,
    required this.isSelected,
    required this.onTap,
    required this.size,
    this.showX = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: isSelected ? size + 4 : size,
        height: isSelected ? size + 4 : size,
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.textDark : AppColors.boardGrid,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: showX
            ? Icon(Icons.close, size: size * 0.55, color: AppColors.textLight)
            : null,
      ),
    );
  }
}
