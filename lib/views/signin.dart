import 'package:flutter/material.dart';
import 'package:quiz_maker/services/auth.dart';
import 'package:flutter/services.dart';
import 'package:quiz_maker/widget/widget.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key, required this.toggleView}) : super(key: key);
  final Function toggleView;
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.white));

    return Scaffold(
      appBar: AppBar(
        title: const AppLogo(),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextFormField(
              validator: (val) {
                return validateEmail(val!) ? 'Enter Valid Email' : null;
              },
              controller: emailEditingController,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            const SizedBox(
              height: 6,
            ),
            TextFormField(
              validator: (val) {
                return val!.isEmpty ? 'Enter Password' : null;
              },
              obscureText: true,
              controller: passwordEditingController,
              decoration: const InputDecoration(hintText: "Password"),
            ),
            const SizedBox(
              height: 24,
            ),
            GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {}
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account',
                  style: TextStyle(color: Colors.black87, fontSize: 17),
                ),
                GestureDetector(
                  onTap: () {
                    widget.toggleView();
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Colors.black87,
                        decoration: TextDecoration.underline,
                        fontSize: 17),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}

bool validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(pattern);
  return !regExp.hasMatch(value);
}
