import 'package:eco_hero_app/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../storage_service.dart';

class OTPVerificationPage extends StatefulWidget {
  final String email;
  final StorageService storageService;  
  final http.Client httpClient; 

  const OTPVerificationPage({
    super.key,
    required this.email,
    required this.storageService,
    required this.httpClient,
  });

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  String? errorMessage;

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
            if (errorMessage != null) 
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final otp = _otpController.text;

                if (otp.isEmpty) {
                  setState(() {
                    errorMessage = "Please enter the OTP";
                  });
                  Fluttertoast.showToast(
                    msg: "Please enter the OTP",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.black54,
                    textColor: Colors.white,
                  );
                  return;
                }

                final response = await widget.httpClient.post(
                  Uri.parse('https://server.eco-hero-app.com/v1/auth/verify/'),
                  body: json.encode({'email': widget.email, 'otp': otp}),
                  headers: {'Content-Type': 'application/json'},
                );

                if (response.statusCode == 200) {
                  final Map<String, dynamic> responseData = json.decode(response.body);
                  final String accessToken = responseData['access'];
                  final String refreshToken = responseData['refresh'];

                  // Write values to storage
                  await widget.storageService.write('accessToken', accessToken);
                  await widget.storageService.write('refreshToken', refreshToken);
                  await widget.storageService.write('email', widget.email);

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
                  setState(() {
                    errorMessage = "Invalid OTP, please try again";
                  });
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
