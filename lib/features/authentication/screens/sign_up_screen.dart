import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/core/widgets/button_widget.dart';
import 'package:techmart_seller/core/widgets/dialog_widget.dart';
import 'package:techmart_seller/core/widgets/snakbar_widget.dart';
import 'package:techmart_seller/core/widgets/text_fields.dart';
import 'package:techmart_seller/features/authentication/bloc/bloc/auth_bloc.dart';
import 'package:techmart_seller/screens/home_screen.dart';
import 'package:techmart_seller/screens/not_verified_screen.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _businessnamecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ErrorState) {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
          custemSnakbar(context, state.error, Colors.red);
        }
        if (state is AuthLoadingState) {
          loadingDialog(context, "Authenticating");
        } else if (state is NotVerifiedState) {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => NotVerifiedScreen()),
          );
        } else if (state is AuthenticatedState) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SellerHomeScreen()),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: Card(
            color: Colors.white,
            elevation: 5,
            child: Container(
              padding: EdgeInsets.all(20),
              height: 750,
              width: 500,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Join as a Seller",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text("Start your journey with us today"),
                    SizedBox(height: 10),
                    CustemTextFIeld(
                      label: "Business Name",
                      hintText: "Enter your business name",
                      controller: _businessnamecontroller,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Business name is required';
                        }
                        return null;
                      },
                    ),
                    CustemTextFIeld(
                      label: "Seller Name",
                      hintText: "Enter your name",
                      controller: _namecontroller,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    CustemTextFIeld(
                      label: "Email",
                      hintText: "Enter your Email",
                      controller: _emailcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email cannot be empty";
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    CustemTextFIeld(
                      label: "Password",
                      hintText: "Create password",
                      controller: _passwordcontroller,
                      password: true,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    CustemTextFIeld(
                      label: "Confirm your password",
                      hintText: "Re-enter your password",
                      controller: _confirmPasswordController,
                      password: true,
                      validator: (value) {
                        if (value != _passwordcontroller.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    CustemTextFIeld(
                      label: "Phone Number",
                      hintText: "+91 9876543210",
                      controller: _phoneNumber,

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Phone number is required';
                        }
                        if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustemButton(
                      label: "Sign Up",
                      onpressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            SignUpAuth(
                              _emailcontroller.text,
                              _passwordcontroller.text,
                              _namecontroller.text,
                              _businessnamecontroller.text,
                              _phoneNumber.text,
                            ),
                          );
                        }
                      },
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
