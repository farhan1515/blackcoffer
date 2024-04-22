import 'package:blackcoffer/OTP_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
//import 'package:path_provider/path_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNumberController = TextEditingController();



 // Send OTP
void sendCode(BuildContext context) async {
  String phoneNumber = phoneNumberController.text.trim();
  if (phoneNumber.isNotEmpty) {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber', // Prefix with the country code
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error occurred', e.code);
        },
        codeSent: (String verificationId, int? resendToken) {
          Get.to(OTPage(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      Get.snackbar('Error occurred', e.toString());
    }
  } else {
    Get.snackbar('Error', 'Please enter a phone number.');
  }
}

  @override
  Widget build(BuildContext context) {
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
                'Log In',
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: IntlPhoneField(
                    controller: phoneNumberController,
                    initialCountryCode: 'IN',
                    decoration: InputDecoration(
                      hintText: '1234567890',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(217, 186, 248, 1),
                      ),
                      contentPadding: EdgeInsets.only(top: 4, left: 0),
                      border: InputBorder.none,
                    ),
                    onChanged: (phone) {
                      print(phone.completeNumber);
                    },
                  ),
                ),
              ),
              SizedBox(height: 47),
              ElevatedButton(
                onPressed: () {
                  sendCode(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(60, 15, 92, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: Size(120, 50),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
