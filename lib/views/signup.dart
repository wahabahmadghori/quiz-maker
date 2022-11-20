import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_maker/helper/constants.dart';
import 'package:quiz_maker/services/auth.dart';
import 'package:quiz_maker/services/Database.dart';
import 'package:quiz_maker/views/home.dart';
import 'package:quiz_maker/widget/widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key, required this.toggleView}) : super(key: key);
  final Function toggleView;
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthService authService = AuthService();
  DatabaseService databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String email = '', password = '', name = '';

  getInforAndSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      await authService
          .signUpWithEmailAndPassword(email, password)
          .then((value) {
        Map<String, dynamic> userInfo = {"userName": name, "email": email};
        databaseService.addData(userInfo);
        Constants.savedUserLogInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Home()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const AppLogo(),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (val) =>
                                val!.isEmpty ? "Enter an Name" : null,
                            decoration: const InputDecoration(hintText: "Name"),
                            onChanged: (val) {
                              name = val;
                            },
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            validator: (val) => validateEmail(val!)
                                ? "Enter a Valid Email"
                                : null,
                            decoration:
                                const InputDecoration(hintText: "Email"),
                            onChanged: (val) {
                              email = val;
                            },
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (val) => val!.length < 6
                                ? "Password must be 6+ characters"
                                : null,
                            decoration:
                                const InputDecoration(hintText: "Password"),
                            onChanged: (val) {
                              password = val;
                            },
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          GestureDetector(
                            onTap: () {
                              getInforAndSignUp();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 20),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
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
                                'Already have and account? ',
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 17),
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.toggleView();
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    decoration: TextDecoration.underline,
                                    fontSize: 17,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ))
                ],
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
