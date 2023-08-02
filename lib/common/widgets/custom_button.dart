import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messwenger/common/utls/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
   final VoidCallback onPressed;
  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed:onPressed ,
     child: Text(text,
     style: GoogleFonts.roboto(
      color: blackColor),),
      style: ElevatedButton.styleFrom(
        backgroundColor: tabColor,
        minimumSize: const Size(double.infinity, 50)
      ),);
  }
}