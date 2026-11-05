import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackbuddy/Components/theme.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: C.maroon,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.groups_rounded, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 8),
        Text('TrackBuddy',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
      ],
    );
  }
}
