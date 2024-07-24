import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';
import '../storage_service.dart'; // Import the StorageService

class OTPVerificationPage extends StatelessWidget {
  final String email;
  final TextEditingController _otpController = TextEditingController();

  OTPVerificationPage({super.key, required this.email});

  final StorageService storage = StorageService(); // Use StorageService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final otp = _otpController.text;

                if (otp.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please enter the OTP",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.black54,
                    textColor: Colors.white,
                  );
                  return;
                }

                final response = await http.post(
                  Uri.parse('https://server.eco-hero-app.com/v1/auth/verify/'),
                  body: json.encode({'email': email, 'otp': otp}),
                  headers: {'Content-Type': 'application/json'},
                );

                if (response.statusCode == 200) {
                  final Map<String, dynamic> responseData = json.decode(response.body);
                  final String accessToken = responseData['access'];
                  final String refreshToken = responseData['refresh'];

                  // Write values to storage
                  await storage.write('accessToken', accessToken);
                  await storage.write('refreshToken', refreshToken);
                  await storage.write('email', email);

                  Fluttertoast.showToast(
                    msg: "OTP Verified, Account Login Successful",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  );

                  // Navigate back to MainPage
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                    (route) => false,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "Invalid OTP, please try again",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
