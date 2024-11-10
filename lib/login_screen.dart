import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  //loading delay
  Duration get loadingTime => const Duration(seconds: 3);

  //login
  Future<String?> _authUser(LoginData data){
    return Future.delayed(loadingTime).then((value) => null);
  }

  //forget password
  Future<String?> _recoverPassword(String data){
    return Future.delayed(loadingTime).then((value) => null);
  }

  //signup user
  Future<String?> _signupUser(SignupData data){
    return Future.delayed(loadingTime).then((value) => null);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
          onLogin: _authUser,
          onRecoverPassword: _recoverPassword,
        onSignup: _signupUser,
      ),
    );
  }
}
