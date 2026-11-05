import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackbuddy/Screens/page_shell.dart';
import 'package:trackbuddy/Screens/sign_in.dart';

import '../Components/button.dart';
import '../Components/theme.dart';
import '../main.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bebas Dari Ketidakpastian',
              style: GoogleFonts.inter(
                  fontSize: 24, fontWeight: FontWeight.w800, color: C.ink)),
          Text('Maksimalkan Waktu Kuliahmu!',
              style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w700, color: C.charcoal)),
          const SizedBox(height: 14),
          Text(
            'Aplikasi penunjang akademik untuk melacak kehadiran dosen secara '
                'real-time dan memfasilitasi kelompok belajar efektif berkapasitas '
                'maksimal 5 orang.',
            style: GoogleFonts.inter(fontSize: 13, color: C.grey, height: 1.45),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: darkButton(radius: 8),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const LoginPage())),
            child: const Text('Yuk Mulai!'),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/campus.jpg',
                    fit: BoxFit.cover,
                    // Falls back to a gradient until you add the photo.
                    errorBuilder: (_, __, ___) => Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [C.slate, C.beige, C.brown],
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.account_balance_rounded,
                            size: 96, color: Colors.white70),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
