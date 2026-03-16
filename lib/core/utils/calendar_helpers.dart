import '../../models/month_data.dart';

class CalendarHelpers {
  CalendarHelpers._();

  /// Génère les 12 MonthData pour une année donnée (sans notes ni events)
  static List<MonthData> generateYear(int year) {
    return List.generate(
      12,
      (i) => MonthData(year: year, month: i + 1),
    );
  }

  /// Index 0-11 du mois courant
  static int get currentMonthIndex => DateTime.now().month - 1;

  /// Retourne l'index (0-11) à partir d'un mois/année
  static int monthIndex(int month) => month - 1;

  /// Navigue au mois précédent — gère le changement d'année
  static ({int year, int month}) previousMonth(int year, int month) {
    if (month == 1) return (year: year - 1, month: 12);
    return (year: year, month: month - 1);
  }

  /// Navigue au mois suivant — gère le changement d'année
  static ({int year, int month}) nextMonth(int year, int month) {
    if (month == 12) return (year: year + 1, month: 1);
    return (year: year, month: month + 1);
  }
}
