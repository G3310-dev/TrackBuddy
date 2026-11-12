import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackbuddy/Screens/page_shell.dart';
import 'package:trackbuddy/Screens/profile.dart';
import 'package:trackbuddy/Screens/study_group.dart';

import '../Components/menu_card.dart';
import '../Components/theme.dart';
import 'lecturer_search.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    void go(Widget page) =>
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

    final currentUser = FirebaseAuth.instance.currentUser;
    final userEmail = currentUser?.email ?? 'Mahasiswa TrackBuddy';
    final userName = userEmail.contains('@') ? userEmail.split('@')[0] : userEmail;

    final now = DateTime.now();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    const days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jum\'at', 'Sabtu'];
    final formattedDate = '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]} ${now.year}';

    return PageShell(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER & PROFIL RINGKAS ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade600,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Hai, $userName! 👋',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => go(const ProfilePage()),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: C.maroon, width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: C.maroon,
                      child: Icon(Icons.person_rounded, color: Colors.white, size: 22),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // --- BANNER / QUICK INFO CARD ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [C.maroon, C.maroon.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: C.maroon.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Siap hadapi perkuliahan & ujian hari ini?',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cek kehadiran dosen atau bentuk kelompok belajarmu sekarang.',
                          style: GoogleFonts.inter(
                            color: Colors.white60,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.school_rounded,
                    size: 48,
                    color: Colors.white24,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // --- CUSTOM SUBTITLE / SECTION LABEL (TANPA HEADING) ---
            Text(
              'Pilih aktivitas yang ingin kamu lakukan',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),

            // --- MENU CARDS ---
            MenuCard(
              icon: Icons.person_search_rounded,
              title: 'Lacak Kehadiran Dosen',
              desc: 'Apakah sudah ada tanda-tanda kehadiran beliau di kampus?',
              filled: true,
              onTap: () => go(const LecturerSearchPage()),
            ),
            const SizedBox(height: 4),
            MenuCard(
              icon: Icons.menu_book_rounded,
              title: 'Cari Teman Belajar',
              desc: 'Daripada pusing belajar sendiri, mending cari temen aja!',
              filled: true,
              onTap: () => go(const StudyGroupsPage()),
            ),
            const SizedBox(height: 4),
            MenuCard(
              icon: Icons.account_circle_outlined,
              title: 'Cek Profil Kamu',
              desc: 'Coba di cek dulu, siapa tau akunnya ketuker',
              filled: false,
              onTap: () => go(const ProfilePage()),
            ),
          ],
        ),
      ),
    );
  }
}