import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kprimarytheme = Color(0xFFffbe23);
const Color ksecondary = Color(0xFFe8e3d0);
const Color klightGray = Color(0xFF8f8f8f);
const Color kbackground = Color(0xFFf2f2f2);
const Color korange = Color(0xFFf05b24);
TextStyle appBarStyleText = const TextStyle(
    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);

TextStyle kLoginTitleStyle(Size size) => GoogleFonts.ubuntu(
      fontSize: size.height * 0.060,
      fontWeight: FontWeight.bold,
    );

TextStyle kLoginSubtitleStyle(Size size) => GoogleFonts.ubuntu(
      fontSize: size.height * 0.030,
    );

TextStyle kTextFormFieldStyle() => const TextStyle(color: Colors.black);

TextStyle kHaveAnAccountStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: size.height * 0.022, color: Colors.black);

TextStyle kLoginOrSignUpTextStyle(
  Size size,
) =>
    GoogleFonts.ubuntu(
      fontSize: size.height * 0.022,
      fontWeight: FontWeight.w500,
      color: Colors.deepPurpleAccent,
    );
