import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Components/theme.dart';
import 'Database/firebase_options.dart';
import 'Screens/on_boarding.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for the current platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(TrackBuddyApp());
}
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