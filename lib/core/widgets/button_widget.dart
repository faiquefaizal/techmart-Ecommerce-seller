import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustemButton extends StatelessWidget {
  String label;
  VoidCallback onpressed;
  Widget? child;
  Color color;
  Color textcolor;
  CustemButton({
    required this.label,
    required this.onpressed,
    this.child,
    this.color = Colors.black,
    this.textcolor = Colors.white,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        ),
        onPressed: onpressed,
        child:
            child ??
            Text(
              label,
              style: GoogleFonts.lato(
                color: textcolor,

                fontSize: 25,
                fontWeight: FontWeight.w400,
              ),
            ),
      ),
    );
  }
}
