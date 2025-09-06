import 'package:flutter/material.dart';

Widget custemCard(String title, String count, IconData icon) {
  return SizedBox(
    height: 100,
    child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blue, size: 30),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(count, style: TextStyle(fontSize: 20, color: Colors.blue)),
          ],
        ),
      ),
    ),
  );
}
