import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../storage_service.dart';
import 'otp_verification_page.dart';

class EmailEntryPage extends StatefulWidget {
  final StorageService storageService;
  final http.Client httpClient;

  const EmailEntryPage({super.key, required this.storageService, required this.httpClient});

  @override
  _EmailEntryPageState createState() => _EmailEntryPageState();
}

class _EmailEntryPageState extends State<EmailEntryPage> {
  final TextEditingController _emailController = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Email'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
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
                  final email = _emailController.text;

                  if (email.isEmpty) {
                    setState(() {
                      errorMessage = "Please enter your email";
                    });
                    Fluttertoast.showToast(
                      msg: "Please enter your email",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black54,
                      textColor: Colors.white,
                    );
                    return;
                  }

                  final response = await widget.httpClient.post(
                    Uri.parse('https://server.eco-hero-app.com/v1/auth/token/'),
                    body: json.encode({'email': email}),
                    headers: {'Content-Type': 'application/json'},
                  );

                  if (response.statusCode == 200) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OTPVerificationPage(
                          email: email, 
                          storageService: widget.storageService, 
                          httpClient: widget.httpClient,
                        ),
                      ),
                    );
                  } else {
                    setState(() {
                      errorMessage = "Failed to request OTP. Please try again.";
                    });
                    Fluttertoast.showToast(
                      msg: "Failed to request OTP. Please try again.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black54,
                      textColor: Colors.white,
                    );
                  }
                },
                child: const Text('Request OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
