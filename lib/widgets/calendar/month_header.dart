import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

const List<String> kDayHeaders = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

class MonthHeader extends StatelessWidget {
  final bool isMain; // true = mois central, false = mini
  const MonthHeader({super.key, required this.isMain});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (i) {
        final isWeekend = i == 0 || i == 6;
        return Expanded(
          child: Center(
            child: Text(
              kDayHeaders[i],
              style: (isMain
                      ? AppTextStyles.monthMainDayHeader
                      : AppTextStyles.monthMiniDayHeader)
                  .copyWith(
                color: isWeekend
                    ? AppColors.sundayRed.withOpacity(0.7)
                    : null,
              ),
            ),
          ),
        );
      }),
    );
  }
}
