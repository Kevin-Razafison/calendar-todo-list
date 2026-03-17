import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/notes_provider.dart';
import 'providers/calendar_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  final notesProvider = NotesProvider();
  await notesProvider.loadAll();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: notesProvider),
        ChangeNotifierProvider(
          create: (_) => CalendarProvider(notesProvider: notesProvider),
        ),
      ],
      child: CalendarBoardApp(navigatorKey: navigatorKey),
    ),
  );
}
