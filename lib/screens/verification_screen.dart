import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ivykids_assignment/screens/home_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../widgets/round_button.dart';

class VerificationScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const VerificationScreen(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool loading = false;
  final codeController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final number = widget.phoneNumber;
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
              const Image(image: AssetImage('images/verification.png')),
              const Center(
                child: Text(
                  'Verification Code',
                  style: TextStyle(
                      color: Colors.green, fontFamily: 'Poppins', fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Center(child: Text('Please Enter Code sent to\n $number')),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  'Enter Your OTP',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              PinCodeTextField(
                controller: codeController,
                appContext: context,
                length: 6,
                enabled: true,
                onChanged: (value) {},
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  inactiveColor: Colors.black,
                  selectedColor: Colors.pink,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              RoundButton(
                  title: 'Verify',
                  loading: loading,
                  onTap: () async {
                    final credential = PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: codeController.text.toString());
                    try {
                      await auth.signInWithCredential(credential);
                      setState(() {
                        loading = true;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    } catch (e) {
                      print(e.toString());
                    }
                    setState(() {
                      loading = false;
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
