import 'package:flutter/material.dart';

loadingDialog(BuildContext context, String text) {
  return showDialog(
    context: context,
    builder:
        (context) => Dialog(
          elevation: 10,
          child: Container(
            padding: EdgeInsets.all(30),
            width: 30,
            height: 130,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.blue),
                SizedBox(height: 10),
                Text(text),
              ],
            ),
          ),
        ),
  );
}
