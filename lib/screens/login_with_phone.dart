import 'package:ivykids_assignment/screens/verification_screen.dart';
import 'package:ivykids_assignment/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'OTP Verification',
                  style: TextStyle(
                      color: Colors.green, fontFamily: 'Poppins', fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Center(
                  child: Text(
                      'We will send you a One Time Password \n on this mobile number')),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  'Enter Your Mobile Number',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1)),
                  fillColor: Color.fromARGB(255, 248, 254, 248),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              RoundButton(
                  title: 'SEND OTP',
                  loading: loading,
                  onTap: () {
                    _auth.verifyPhoneNumber(
                      phoneNumber: phoneNumberController.text,
                      verificationCompleted: (_) {},
                      verificationFailed: (error) {
                        setState(() {
                          loading = true;
                        });
                      },
                      codeSent: (String verificationId, int? token) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerificationScreen(
                                      verificationId: verificationId,
                                      phoneNumber:
                                          phoneNumberController.text.toString(),
                                    )));
                        setState(() {
                          loading = true;
                        });
                      },
                      codeAutoRetrievalTimeout: (error) {
                        setState(() {
                          loading = false;
                        });
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
