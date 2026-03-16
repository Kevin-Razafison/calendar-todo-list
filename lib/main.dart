import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/notes_provider.dart';
import 'providers/calendar_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Orientation portrait uniquement (tableau mieux en portrait)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Barre de statut transparente
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Init providers
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
      child: const CalendarBoardApp(),
    ),
  );
}
