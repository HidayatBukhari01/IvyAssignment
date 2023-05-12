import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ivykids_assignment/screens/auth/signup_screen.dart';
import 'package:ivykids_assignment/screens/home_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../firebase/google_auth.dart';
import '../../widgets/round_button.dart';
import '../login_with_phone.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleAuth googleAuth = GoogleAuth();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void logIn() {
    setState(() {
      loading = true;
    });
    _firebaseAuth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      print("User does'nt exist");
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 150,
                ),
                const Text(
                  'Log In',
                  style: TextStyle(fontSize: 40, fontFamily: 'Poppins'),
                ),
                const SizedBox(
                  height: 70,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: 'Email',
                            prefixIcon: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.black,
                            ),
                          ),
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter an email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: 'Password',
                            prefixIcon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter a password";
                            }
                            return null;
                          },
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 30,
                ),
                const Center(
                  child: Text(
                    "- or log in with -",
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        try {
                          googleAuth.signInWithGoogle();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 50,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              FontAwesomeIcons.google,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginWithPhone()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 50,
                        width: 100,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.mobileScreenButton,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                RoundButton(
                  title: 'Log in',
                  loading: loading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      logIn();
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t? have an account? ',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins'),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.green,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
