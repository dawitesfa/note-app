import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/screens/splash_screen.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (fn) => runApp(
      const ProviderScope(child: App()),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        useMaterial3: true,
        textTheme: GoogleFonts.latoTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 250, 149, 198),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 28, 24, 24),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          surface: const Color.fromARGB(255, 33, 28, 28),
          onSurface: Colors.white70,
          onBackground: Colors.white,
        ),
        textTheme: GoogleFonts.latoTextTheme().copyWith(
          headlineLarge: const TextStyle(
            color: Colors.white54,
          ),
          titleLarge: const TextStyle(
            color: Colors.white54,
          ),
          titleMedium: const TextStyle(
            color: Colors.white54,
          ),
          headlineSmall: const TextStyle(
            color: Colors.white54,
          ),
          bodySmall: const TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.w300,
          ),
          bodyMedium: const TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.w300,
          ),
          bodyLarge: const TextStyle(
            color: Colors.white54,
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: Colors.white70,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
