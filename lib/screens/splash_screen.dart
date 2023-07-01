import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/providers/category_provider.dart';
import 'package:todo/providers/pinned_provider.dart';
import 'package:todo/providers/prefs_provider.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/screens/intro_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    ref.read(prefsProvider.notifier).loadPrefs();
    ref.read(pinnedItemsProvider.notifier).loadPins();
    ref.read(catagoriesProvider.notifier).loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      final prefs = ref.watch(prefsProvider);
      final isFirstTime = prefs['isFirstTime'] as bool;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              isFirstTime ? const IntroScreen() : const HomeScreen(),
        ),
      );
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(110 / 2),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.asset(
                'assets/images/app-logo.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'KEEP IT!',
              style: Theme.of(context).textTheme.headlineLarge,
            )
          ],
        ),
      ),
    );
  }
}
