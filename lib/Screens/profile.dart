import 'package:flutter/material.dart';
import 'package:trackbuddy/Screens/page_shell.dart';

import '../Components/button.dart';
import '../Components/heading.dart';
import '../Components/theme.dart';
import 'on_boarding.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageShell(
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Heading('Profil Kamu', 'Pastikan akunnya benar'),
          const SizedBox(height: 32),
          const Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: C.maroon,
              child: Icon(Icons.person_rounded, size: 56, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text('Nama Mahasiswa',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          const Center(
            child: Text('mahasiswa@ui.ac.id', style: TextStyle(color: C.grey)),
          ),
          const SizedBox(height: 28),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.school_rounded, color: C.maroon),
            title: Text('Departemen'),
            subtitle: Text('Teknik Metalurgi dan Material'),
          ),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.groups_rounded, color: C.maroon),
            title: Text('Kelompok belajar diikuti'),
            subtitle: Text('0 kelompok'),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: darkButton(radius: 8),
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const OnboardingPage()),
                    (r) => false,
              ),
              child: const Text('Keluar'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}