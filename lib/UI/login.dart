import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hermes/UI/email_login.dart';
import 'package:hermes/UI/verify_phone_number.dart';
import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:hermes/UI/homepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.onTap}) : super(key: key);

  final Future<void> Function() onTap;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  String FinalPhoneNum = '';

  final TextEditingController phoneController = TextEditingController();
  Country selectedCountry = Country(
    phoneCode: '91',
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'India',
    example: 'India',
    displayName: 'India',
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  Future<void> signInWithPhoneNumber() async {
    setState(() {
      isLoading = true;
    });

    try {
      FinalPhoneNum = '+${selectedCountry.phoneCode}${phoneController.text}';
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: FinalPhoneNum,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failure
          print('Verification Failed: ${e.message}');
          // Show relevant error message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Verification Failed: ${e.message}'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            isLoading = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationScreen(
                verificationId: verificationId,
                phoneNumber: FinalPhoneNum,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Code Auto Retrieval Timeout: $verificationId');
        },
      );
    } catch (e) {
      print('Error signing in with phone number: $e');
      // Show relevant error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneController.text.length),
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logo.png'),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Login',
              style: const TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: phoneController,
              onChanged: (value) {
                setState(() {});
              },
              cursorColor: const Color(0xFF7866FE),
              decoration: InputDecoration(
                prefixIcon: Container(
                  padding: const EdgeInsets.all(12.5),
                  child: InkWell(
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        countryListTheme: const CountryListThemeData(
                          bottomSheetHeight: 600,
                        ),
                        onSelect: (value) {
                          setState(() {
                            selectedCountry = value;
                          });
                        },
                      );
                    },
                    child: Text(
                      "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                suffixIcon: phoneController.text.length > 8
                    ? Container(
                        margin: const EdgeInsets.all(10.0),
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF7866FE),
                        ),
                        child: const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 20,
                        ),
                      )
                    : null,
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                  color: Colors.grey,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: const Color(0xFF7866FE),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: const Color(0xFF7866FE),
                  ),
                ),
              ),
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            ArgonButton(
              height: 50,
              width: 100,
              borderRadius: 30.0,
              color: const Color(0xFF7866FE),
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              loader: Container(
                padding: const EdgeInsets.all(10),
                child: const SpinKitRotatingCircle(
                  color: Colors.white,
                ),
              ),
              onTap: isLoading
                  ? null
                  : (Function startLoading, Function stopLoading,
                      ArgonButtonState state) async {
                      try {
                        startLoading();
                        await signInWithPhoneNumber();
                      } catch (error) {
                        // Handle any errors here, such as displaying an error message to the user
                        print('Error: $error');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $error'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } finally {
                        stopLoading();
                      }
                    },
            ),
            const SizedBox(height: 20.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailLoginScreen()),
                );
              },
              child: const Text(
                'Login with Email',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
