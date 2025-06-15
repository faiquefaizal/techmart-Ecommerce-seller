import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/features/authentication/bloc/bloc/auth_bloc.dart';
import 'package:techmart_seller/screens/home_screen.dart';

class NotVerifiedScreen extends StatelessWidget {
  const NotVerifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => SellerHomeScreen()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hourglass_empty, size: 100, color: Colors.orange),
                const SizedBox(height: 20),
                const Text(
                  "Your account is under review",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Please wait while an admin verifies your details.\nYou'll be notified once it's approved.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
