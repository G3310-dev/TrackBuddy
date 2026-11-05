import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackbuddy/Screens/page_shell.dart';

import '../Components/button.dart';
import '../Components/heading.dart';
import '../Components/input_field.dart';
import '../Components/result.dart';
import '../Components/theme.dart';
import '../Database/placeholder.dart';

class LecturerSearchPage extends StatefulWidget {
  const LecturerSearchPage({super.key});

  @override
  State<LecturerSearchPage> createState() => _LecturerSearchPageState();
}

class _LecturerSearchPageState extends State<LecturerSearchPage> {
  final _name = TextEditingController();
  final _dept = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _dept.dispose();
    super.dispose();
  }

  void _search() {
    final n = _name.text.trim().toLowerCase();
    final d = _dept.text.trim().toLowerCase();
    final results = lecturers
        .where((l) =>
    l.name.toLowerCase().contains(n) &&
        l.department.toLowerCase().contains(d))
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => ResultsSheet(results: results),
    );
  }

  void _report() {
    showDialog(
      context: context,
      builder: (ctx) {
        final loc = TextEditingController();
        return AlertDialog(
          title: Text('Laporan Pencarian',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: _name,
                  decoration: fieldDecoration('Nama dosen yang kamu lihat')),
              const SizedBox(height: 8),
              TextField(
                  controller: loc, decoration: fieldDecoration('Lokasi (mis. Gedung DTMM)')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            ElevatedButton(
              style: darkButton(radius: 8),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Terima kasih, laporanmu terkirim!')));
              },
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageShell(
      showBack: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Heading('Siapa yang kamu cari?', 'Beliau ada gak ya...'),
            const SizedBox(height: 32),
            const Center(
              child: Icon(Icons.search_rounded, size: 190, color: C.maroon),
            ),
            const SizedBox(height: 40),
            TextField(controller: _name, decoration: fieldDecoration('Nama Dosen')),
            const SizedBox(height: 8),
            TextField(controller: _dept, decoration: fieldDecoration('Departemen')),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _search,
                style: ElevatedButton.styleFrom(
                  backgroundColor: C.maroon,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
                ),
                child: const Text('Cari'),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _report,
                style: darkButton(radius: 10).copyWith(
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 2)),
                    textStyle: WidgetStatePropertyAll(
                        GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500))),
                child: const Text('Laporan Pencarian'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}