import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class KioskPageTransitionsBuilder extends PageTransitionsBuilder {
  const KioskPageTransitionsBuilder();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 1150);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 900);

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final fadeInAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeOut,
    );

    final fadeOutAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: secondaryAnimation,
        curve: Curves.easeInOut,
      ),
    );

    return FadeTransition(
      opacity: fadeOutAnimation,
      child: FadeTransition(
        opacity: fadeInAnimation,
        child: child,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Antrian RS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: KioskPageTransitionsBuilder(),
            TargetPlatform.iOS: KioskPageTransitionsBuilder(),
            TargetPlatform.linux: KioskPageTransitionsBuilder(),
            TargetPlatform.macOS: KioskPageTransitionsBuilder(),
            TargetPlatform.windows: KioskPageTransitionsBuilder(),
            TargetPlatform.fuchsia: KioskPageTransitionsBuilder(),
          },
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
