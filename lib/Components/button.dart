import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackbuddy/Components/theme.dart';

ButtonStyle darkButton({double radius = 10}) => ElevatedButton.styleFrom(
  backgroundColor: C.ink,
  foregroundColor: Colors.white,
  elevation: 0,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
  textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
);
