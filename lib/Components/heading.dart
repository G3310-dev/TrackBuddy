import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme.dart';

class Heading extends StatelessWidget {
  final String title;
  final String subtitle;
  const Heading(this.title, this.subtitle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.inter(
                fontSize: 24, fontWeight: FontWeight.w800, color: C.ink, height: 1.15)),
        const SizedBox(height: 2),
        Text(subtitle,
            style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w700, color: C.charcoal)),
      ],
    );
  }
}