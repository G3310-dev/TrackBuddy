import 'package:flutter/material.dart';
import 'package:trackbuddy/Screens/page_shell.dart';
import 'package:trackbuddy/Screens/profile.dart';
import 'package:trackbuddy/Screens/study_group.dart';

import '../Components/heading.dart';
import '../Components/menu_card.dart';
import '../main.dart';
import 'lecturer_search.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    void go(Widget page) =>
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

    return PageShell(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Heading('Apa yang kamu perlu?', 'Kami siap membantumu!'),
            const SizedBox(height: 28),
            MenuCard(
              icon: Icons.person_search_rounded,
              title: 'Lacak Kehadiran Dosen',
              desc: 'Apakah sudah ada tanda-tanda kehadiran beliau di kampus?',
              filled: true,
              onTap: () => go(const LecturerSearchPage()),
            ),
            MenuCard(
              icon: Icons.menu_book_rounded,
              title: 'Cari Teman Belajar',
              desc: 'Daripada pusing belajar sendiri, mending cari temen aja!',
              filled: true,
              onTap: () => go(const StudyGroupsPage()),
            ),
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
