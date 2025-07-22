import 'package:flutter/material.dart';

showALertDialog(BuildContext context, VoidCallback confirmfuntion) {
  return showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text("Delete Coupon"),
          content: const Text("Are you sure you want to delete this?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                confirmfuntion();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
  );
}
