import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackbuddy/Screens/page_shell.dart';

import '../Components/button.dart';
import '../Components/input_field.dart';
import '../Components/theme.dart';
import 'home.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _enter(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageShell(
      showBack: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text('Halo!',
                style: GoogleFonts.inter(
                    fontSize: 36, fontWeight: FontWeight.w800, color: C.ink)),
            Text('Selamat datang di TrackBuddy',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _enter(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: C.ink,
                  side: const BorderSide(color: C.lightGrey),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                icon: const Text('G',
                    style: TextStyle(
                        color: Color(0xFFDB4437),
                        fontWeight: FontWeight.w900,
                        fontSize: 16)),
                label: Text('Sign In With Google',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(height: 18),
            Row(children: [
              const Expanded(child: Divider(color: C.lightGrey)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('Or', style: GoogleFonts.inter(fontSize: 11)),
              ),
              const Expanded(child: Divider(color: C.lightGrey)),
            ]),
            const SizedBox(height: 18),
            TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: fieldDecoration('Email')),
            const SizedBox(height: 8),
            TextField(obscureText: true, decoration: fieldDecoration('Password')),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: darkButton(radius: 8).copyWith(
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 14))),
                onPressed: () => _enter(context), // any input logs in (prototype)
                child: const Text('Masuk'),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Halaman daftar belum dibuat (prototype)'))),
              child: Text('Tidak punya akun? Klik disini',
                  style: GoogleFonts.inter(
                      fontSize: 10, decoration: TextDecoration.underline)),
            ),
          ],
        ),
      ),
    );
  }
}
