import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/core/widgets/button_widget.dart';
import 'package:techmart_seller/core/widgets/dialog_widget.dart';
import 'package:techmart_seller/core/widgets/snakbar_widget.dart';
import 'package:techmart_seller/core/widgets/text_fields.dart';
import 'package:techmart_seller/features/authentication/bloc/bloc/auth_bloc.dart';
import 'package:techmart_seller/features/authentication/screens/sign_up_screen.dart';
import 'package:techmart_seller/screens/home_screen.dart';
import 'package:techmart_seller/screens/not_verified_screen.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  LoginScreen({super.key});

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
        // TODO: implement listener
      },
      child: Scaffold(
        body: Center(
          child: Card(
            elevation: 10,

            child: Container(
              width: 300,
              height: 500,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Text("Welcome back"),
                      Text("login to yout account"),
                      CustemTextFIeld(
                        label: "Email",
                        hintText: "Enter your Email",
                        controller: emailController,
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
                        hintText: "Enter your Password",
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password cannot be empty";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      CustemButton(
                        label: "Login In",
                        onpressed: () {
                          if (_formkey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              LoginAuth(
                                emailController.text,
                                passwordController.text,
                              ),
                            );
                          }
                        },
                        color: Colors.blue,
                      ),
                      Text("Forget Password"),
                      Row(
                        children: [
                          Text("Are you a New Seller? "),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Click Here",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
