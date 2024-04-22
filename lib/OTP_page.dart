import 'package:blackcoffer/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pinput/pinput.dart';

class OTPage extends StatefulWidget {
  final String verificationId; // Verification ID received from login page
  OTPage(
      {required this.verificationId}); // Constructor to receive verification ID

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPage> {
  late TextEditingController _pinController=TextEditingController();
  // late BoxDecoration _pinPutDecoration;

  void signInWithOTP(String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        Get.offAll(Wrapper()); // Navigate to Wrapper after successful login
      });
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error Occurred', e.code);
    } catch (e) {
      Get.snackbar('Error Occurred', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      height: 54,
      width: 59,
      margin: EdgeInsets.symmetric(horizontal: 5),
      textStyle: TextStyle(fontSize: 22, color: Colors.black),
      decoration: BoxDecoration(
          color: Color.fromRGBO(243, 234, 253, 1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.transparent,
          )),
    );
    return Scaffold(
      backgroundColor: Color.fromRGBO(108, 44, 157, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 221),
              Text(
                'Enter OTP',
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 44, left: 18, right: 10),
                child: Pinput(
                  controller: _pinController,
                  length: 5,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!
                          .copyWith(border: Border.all(color: Colors.green))),
                  onCompleted: (pin) => debugPrint(pin),
                  onChanged: (String value) {
                    // Handle OTP input changes
                  },
                  onSubmitted: (String smsCode) {
                    signInWithOTP(smsCode);
                  },
                ),
              ),
              SizedBox(height: 47),
              ElevatedButton(
                onPressed: () {
                  // You can implement manual OTP submission if needed
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(60, 15, 92, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(120, 50),
                ),
                child: Text(
                  'Get started',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
}
