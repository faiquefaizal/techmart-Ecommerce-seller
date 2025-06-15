// import 'dart:async';
// import 'dart:developer';

// import 'package:bloc/bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';

// import 'package:techmart_seller/features/authentication/services/authentication_service.dart';

// part 'auth_event.dart';
// part 'auth_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   AuthenticationService auth = AuthenticationService();
//   StreamSubscription<bool>? _sellerSubscription;
//   AuthBloc() : super(AuthInitial()) {
//     on<AuthEvent>((event, emit) {
//       // TODO: implement event handler
//     });
//     on<LoginAuth>(_loginEvent);
//     on<SignUpAuth>(_registerEvent);
//   }

//   _loginEvent(LoginAuth event, Emitter<AuthState> emit) async {
//     emit(AuthLoadingState());
//     try {
//       await Future.delayed(Duration(seconds: 2));
//       final userId = await auth.loginIn(event.email, event.password);
//       _startListeningToSellerVerification(userId!, emit);
//     } on FirebaseAuthException catch (e) {
//       emit(ErrorState(e.message.toString()));
//     }
//   }

//   _registerEvent(SignUpAuth event, Emitter<AuthState> emit) async {
//     log("called");
//     emit(AuthLoadingState());
//     try {
//       await Future.delayed(Duration(seconds: 3));
//       final userId = await auth.registerSeller(
//         email: event.email,
//         password: event.password,
//         name: event.name,
//         businessname: event.businessname,
//         phonenumber: event.phonenumber,
//       );
//       log("called auth");
//       emit(AuthenticatedState(userId!));
//     } on FirebaseAuthException catch (e) {
//       log("called error");
//       emit(ErrorState(e.message.toString()));
//     }
//   }

//   Future<void> _startListeningToSellerVerification(
//     String userId,
//     Emitter<AuthState> emit,
//   ) async {
//     await emit.forEach<bool>(
//       auth.sellerVerificationStatus(userId),
//       onData: (isVerified) {
//         return isVerified ? AuthenticatedState(userId) : NotVerifiedState();
//       },
//       onError: (error, _) => ErrorState(error.toString()),
//     );
//   }
// }
import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:techmart_seller/features/authentication/services/authentication_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthenticationService auth = AuthenticationService();
  StreamSubscription<bool>? _sellerSubscription;

  AuthBloc() : super(AuthInitial()) {
    on<LoginAuth>(_loginEvent);
    on<SignUpAuth>(_registerEvent);
    on<CheckVerificationStatus>(_checkVerificationStatus);
  }

  _loginEvent(LoginAuth event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      await Future.delayed(Duration(seconds: 2));
      final userId = await auth.loginIn(event.email, event.password);
      _startListeningToSellerVerification(userId!, emit);
    } on FirebaseAuthException catch (e) {
      emit(ErrorState(e.message.toString()));
    }
  }

  // _registerEvent(SignUpAuth event, Emitter<AuthState> emit) async {
  //   log("called");
  //   emit(AuthLoadingState());
  //   try {
  //     await Future.delayed(Duration(seconds: 3));
  //     final userId = await auth.registerSeller(
  //       email: event.email,
  //       password: event.password,
  //       name: event.name,
  //       businessname: event.businessname,
  //       phonenumber: event.phonenumber,
  //     );
  //     log("called auth");
  //     emit(AuthenticatedState(userId!));
  //   } on FirebaseAuthException catch (e) {
  //     log("called error");
  //     emit(ErrorState(e.message.toString()));
  //   }
  // }

  _registerEvent(SignUpAuth event, Emitter<AuthState> emit) async {
    log("Register event triggered");
    emit(AuthLoadingState());
    try {
      await Future.delayed(Duration(seconds: 3));
      final userId = await auth.registerSeller(
        email: event.email,
        password: event.password,
        name: event.name,
        businessname: event.businessname,
        phonenumber: event.phonenumber,
      );
      log("Registration successful, checking verification...");
      await _startListeningToSellerVerification(userId!, emit);
    } on FirebaseAuthException catch (e) {
      log("Registration error: ${e.message}");
      emit(ErrorState(e.message.toString()));
    }
  }

  Future<void> _startListeningToSellerVerification(
    String userId,
    Emitter<AuthState> emit,
  ) async {
    await emit.forEach<bool>(
      auth.sellerVerificationStatus(userId),
      onData: (isVerified) {
        return isVerified ? AuthenticatedState(userId) : NotVerifiedState();
      },
      onError: (error, _) => ErrorState(error.toString()),
    );
  }

  Future<void> _checkVerificationStatus(
    CheckVerificationStatus event,
    Emitter<AuthState> emit,
  ) async {
    await _startListeningToSellerVerification(event.userId, emit);
  }
}
