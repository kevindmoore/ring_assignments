import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:lumberdash/lumberdash.dart';
import 'package:colorize_lumberdash/colorize_lumberdash.dart';

import 'app_router.dart';

final _appRouter = AppRouter();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SignalsObserver.instance = null;
  putLumberdashToWork(withClients: [ColorizeLumberdash()]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Ring Assignments',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1D4ED8),
          onPrimary: Colors.white,
          primaryContainer: Color(0xFFDBEAFE),
          onPrimaryContainer: Color(0xFF102A56),
          secondary: Color(0xFF0891B2),
          onSecondary: Colors.white,
          secondaryContainer: Color(0xFFCFFAFE),
          onSecondaryContainer: Color(0xFF164E63),
          tertiary: Color(0xFFF59E0B),
          onTertiary: Color(0xFF082F49),
          tertiaryContainer: Color(0xFFFEF3C7),
          onTertiaryContainer: Color(0xFF78350F),
          surface: Color(0xFFF8FBFF),
          onSurface: Color(0xFF082F49),
          onSurfaceVariant: Color(0xFF1E40AF),
          outline: Color(0xFF93B4D7),
        ),
        scaffoldBackgroundColor: const Color(0xFFE8F4FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFD7EAFE),
          foregroundColor: Color(0xFF0F172A),
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFBBD4EF)),
          ),
        ),
        listTileTheme: const ListTileThemeData(iconColor: Color(0xFF0891B2)),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF1D4ED8),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFFCFE8FF),
          indicatorColor: const Color(0xFF93C5FD),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              color: states.contains(WidgetState.selected)
                  ? const Color(0xFF082F49)
                  : const Color(0xFF1E40AF),
              fontSize: 12,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w600,
            ),
          ),
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? const Color(0xFF1E3A8A)
                  : const Color(0xFF2563EB),
            ),
          ),
        ),
      ),
      routerConfig: _appRouter.config(),
    );
  }
}
