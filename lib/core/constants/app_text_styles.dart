import 'package:flutter/material.dart';
import 'app_colors.dart';


class AppTextStyles {
  AppTextStyles._();

  //Police manuscrite (posts-its)
  static const String _handwrittenFont = 'Caveat';
  static const String _boardFont       = 'Roboto';


  //Mois central
  static const TextStyle monthMainTitle = TextStyle(
    fontFamily: _boardFont,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    letterSpacing: 2.0,
    color: AppColors.textMonthTitle,
  );

  static const TextStyle monthMainDayHeader = TextStyle(
    fontFamily: _boardFont,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textMedium,
    letterSpacing: 1.5,
  );

  static const TextStyle monthMainDayNumber = TextStyle (
    fontFamily: _boardFont,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static const TextStyle monthMainDayNumberToday = TextStyle (
    fontFamily: _boardFont,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle monthMainDayNumbearSunday = TextStyle (
    fontFamily: _boardFont,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.sundayRed,
  );

  //Mois mini
  
  static const TextStyle monthMiniTitle = TextStyle (
    fontFamily: _boardFont,
    fontSize: 9,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.5,
    color: AppColors.textDark,
  );

  
  static const TextStyle monthMiniDayHeaderr = TextStyle (
    fontFamily: _boardFont,
    fontSize: 7,
    fontWeight: FontWeight.w600,
    color: AppColors.textMedium,
    letterSpacing: 0.8,
  );

  static const TextStyle monthMiniDayNumber = TextStyle (
    fontFamily: _boardFont,
    fontSize: 8,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
  );


  static const TextStyle monthMiniDayNumberSunday = TextStyle (
    fontFamily: _boardFont,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.sundayRed,
  );


  // Post-its
  static const TextStyle stickyNoteMain = TextStyle (
    fontFamily: _handwrittenFont,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnSticky,
    height:1.3,
  );

  static const TextStyle stickyNoteMini = TextStyle (
    fontFamily: _handwrittenFont,
    fontSize: 9,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnSticky,
    height: 1.2,
  );

  //Dialog /UI
  static const TextStyle dialogTitle = TextStyle(
    fontFamily: _handwrittenFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnSticky,
  );

  static const TextStyle dialogInput = TextStyle (
    fontFamily: _handwrittenFont,
    fontSize: 16,
    color: AppColors.textDark,
    height: 1.4,
  );
}
