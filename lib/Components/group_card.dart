import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackbuddy/Components/theme.dart';

import '../Database/placeholder.dart';
import 'button.dart';

class GroupCard extends StatelessWidget {
  final StudyGroup group;
  final VoidCallback onToggle;
  const GroupCard({super.key, required this.group, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final full = group.joined >= group.capacity && !group.isMine;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: C.shadow, blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(group.course,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w800, fontSize: 13, color: C.maroon)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                  decoration: const BoxDecoration(
                    color: C.maroon,
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                  ),
                  child: Text(group.tag,
                      style: GoogleFonts.inter(
                          color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(Icons.location_on_rounded, group.place),
                const SizedBox(height: 4),
                _infoRow(Icons.access_time_rounded, group.schedule),
                const SizedBox(height: 8),
                Text('Keterangan:',
                    style: GoogleFonts.inter(
                        fontSize: 10, fontWeight: FontWeight.w800, color: C.maroon)),
                const SizedBox(height: 2),
                Text(group.note,
                    style: GoogleFonts.inter(fontSize: 10, color: C.charcoal, height: 1.4)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: full ? null : onToggle,
                  style: darkButton(radius: 6).copyWith(
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                    minimumSize: const WidgetStatePropertyAll(Size(0, 0)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(full ? 'Penuh' : (group.isMine ? 'Keluar' : 'Ikut dong'),
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 14),
                      Text('${group.joined}/${group.capacity}',
                          style: GoogleFonts.inter(fontSize: 8)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 14, color: C.grey),
      const SizedBox(width: 6),
      Text(text, style: GoogleFonts.inter(fontSize: 9, color: C.charcoal)),
    ],
  );
}
