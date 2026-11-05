import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackbuddy/Screens/page_shell.dart';

import '../Components/button.dart';
import '../Components/group_card.dart';
import '../Components/heading.dart';
import '../Components/input_field.dart';
import '../Components/theme.dart';
import '../Database/placeholder.dart';

class StudyGroupsPage extends StatefulWidget {
  const StudyGroupsPage({super.key});

  @override
  State<StudyGroupsPage> createState() => _StudyGroupsPageState();
}

class _StudyGroupsPageState extends State<StudyGroupsPage> {
  final groups = buildGroups();

  void _toggle(StudyGroup g) {
    setState(() {
      if (g.isMine) {
        g.isMine = false;
        g.joined--;
      } else if (g.joined < g.capacity) {
        g.isMine = true;
        g.joined++;
      }
    });
  }

  void _create() {
    final course = TextEditingController();
    final place = TextEditingController();
    final note = TextEditingController();
    String tag = 'UTS';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text('Buat Kelompok Belajar',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: course, decoration: fieldDecoration('Nama mata kuliah')),
                const SizedBox(height: 8),
                TextField(controller: place, decoration: fieldDecoration('Lokasi')),
                const SizedBox(height: 8),
                TextField(
                    controller: note,
                    maxLines: 2,
                    decoration: fieldDecoration('Keterangan')),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: tag,
                  decoration: fieldDecoration('Jenis'),
                  items: const ['UTS', 'UAS', 'Tugas', 'Kuis']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setLocal(() => tag = v ?? tag),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            ElevatedButton(
              style: darkButton(radius: 8),
              onPressed: () {
                if (course.text.trim().isEmpty) return;
                setState(() => groups.insert(
                  0,
                  StudyGroup(
                    course: course.text.trim(),
                    place: place.text.trim().isEmpty ? 'Lokasi menyusul' : place.text.trim(),
                    schedule: 'Hari ini · 15.00-17.00',
                    note: note.text.trim().isEmpty ? 'Belum ada keterangan.' : note.text.trim(),
                    tag: tag,
                    joined: 1,
                    isMine: true,
                  ),
                ));
                Navigator.pop(ctx);
              },
              child: const Text('Buat'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageShell(
      showBack: true,
      fab: FloatingActionButton(
        onPressed: _create,
        backgroundColor: C.maroon,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Heading('Hari ini mau belajar apa?', 'Mending pusingnya bareng-bareng'),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 96, top: 4),
              itemCount: groups.length,
              itemBuilder: (_, i) =>
                  GroupCard(group: groups[i], onToggle: () => _toggle(groups[i])),
            ),
          ),
        ],
      ),
    );
  }
}
