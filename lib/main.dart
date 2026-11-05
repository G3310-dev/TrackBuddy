import 'package:flutter/material.dart';

import 'Components/theme.dart';
import 'Screens/on_boarding.dart';

void main() => runApp(const TrackBuddyApp());

class TrackBuddyApp extends StatelessWidget {
  const TrackBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackBuddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: C.maroon, primary: C.maroon),
      ),
      home: const OnboardingPage(),
    );
  }
}