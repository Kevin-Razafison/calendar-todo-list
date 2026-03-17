import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/board_screen.dart';

class CalendarBoardApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const CalendarBoardApp({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Board',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.caveatTextTheme(),
        scaffoldBackgroundColor: const Color(0xFF1A0F08),
      ),
      home: const BoardScreen(),
    );
  }
}
