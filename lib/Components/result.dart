import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackbuddy/Components/theme.dart';

import '../Database/placeholder.dart';

class ResultsSheet extends StatelessWidget {
  final List<Lecturer> results;
  const ResultsSheet({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hasil Pencarian',
              style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 12),
          if (results.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text('Dosen tidak ditemukan. Coba kata kunci lain.',
                  style: GoogleFonts.inter(color: C.grey)),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: results.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final l = results[i];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: l.present ? C.maroon : C.lightGrey,
                      child: Icon(
                          l.present ? Icons.check_rounded : Icons.help_outline_rounded,
                          color: Colors.white),
                    ),
                    title: Text(l.name,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    subtitle: Text('${l.department}\n${l.info}',
                        style: GoogleFonts.inter(fontSize: 11)),
                    isThreeLine: true,
                    trailing: Text(l.present ? 'Ada' : 'Belum',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            color: l.present ? C.maroon : C.grey)),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
