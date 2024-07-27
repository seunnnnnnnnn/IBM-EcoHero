import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../storage_service.dart'; // Import the StorageService
import 'camera_access.dart';
import '../widgets/bin_button.dart';
import '../main.dart'; // Import the MainApp for navigation

class CameraScreen extends StatefulWidget {
  final bool isTeamScan; // Add this to differentiate between home and team scans

  const CameraScreen({super.key, this.isTeamScan = false});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final CameraAccess _cameraAccess = CameraAccess();
  final StorageService storage = StorageService(); // Use StorageService
  bool _isPickingImage = false;

  Future<void> _pickImage(BuildContext context) async {
    if (_isPickingImage) return;

    setState(() {
      _isPickingImage = true;
    });

    try {
      Uint8List? imageData = await _cameraAccess.pickImage();

      if (imageData != null) {
        _analyzeImage(imageData, widget.isTeamScan);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image captured.')),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    } finally {
      setState(() {
        _isPickingImage = false;
      });
    }
  }

  Future<void> _analyzeImage(Uint8List imageData, bool isTeamScan) async {
    _showLoadingDialog();
    try {
      String? token = await storage.read('accessToken'); // Read the access token from storage
      var headers = {
        'Authorization': 'Bearer $token'
      };
      var request = http.MultipartRequest('POST', Uri.parse('https://server.eco-hero-app.com/v1/scan/upload/'));
      request.files.add(http.MultipartFile.fromBytes('image', imageData, filename: 'scan.jpg'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      Navigator.of(context).pop(); // Close the loading dialog

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final data = json.decode(responseData.body);
        final imageUrl = data['image_url'];
        final description = data['description'];
        final binColor = data['color'];
        _showResultDialog(imageUrl, description, binColor, isTeamScan);
      } else {
        print('Error analyzing image: ${response.statusCode}');
        final responseData = await http.Response.fromStream(response);
        print('Response Body: ${responseData.body}'); // Add this line
      }
    } catch (e) {
      print('Error analyzing image: $e');
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Analyzing...'),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showResultDialog(String imageUrl, String description, String binColor, bool isTeamScan) async {
    Color dialogColor;
    switch (binColor.toLowerCase()) {
      case 'green':
        dialogColor = Colors.green;
        break;
      case 'black':
        dialogColor = Colors.black;
        break;
      case 'blue':
        dialogColor = Colors.blue;
        break;
      default:
        dialogColor = Colors.grey;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Analysis Result',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(imageUrl),
              const SizedBox(height: 10),
              Text(description),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BinButton('Black', Colors.black, binColor, (correctBin, selectedBin) => _confirmBinSelection(correctBin, selectedBin, isTeamScan)),
                  BinButton('Green', Colors.green, binColor, (correctBin, selectedBin) => _confirmBinSelection(correctBin, selectedBin, isTeamScan)),
                  BinButton('Blue', Colors.blue, binColor, (correctBin, selectedBin) => _confirmBinSelection(correctBin, selectedBin, isTeamScan)),
                ],
              ),
            ],
          ),
          backgroundColor: dialogColor,
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmBinSelection(String correctBin, String selectedBin, bool isTeamScan) async {
    String? token = await storage.read('accessToken'); // Read the access token from storage
    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('https://server.eco-hero-app.com/v1/scan/confirm-bin/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({
            'bin_color': correctBin,
            'color': selectedBin,
          }),
        );

        if (response.statusCode == 200) {
          if (correctBin == selectedBin) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Correct! Points awarded!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Incorrect bin. Try again!')),
            );
          }
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()), // Navigate to MainPage to ensure the bottom navigation bar is present
            (route) => false,
          );
        } else {
          print('Error confirming bin: ${response.statusCode}');
        }
      } catch (e) {
        print('Error confirming bin: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco Hero'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _pickImage(context),
          child: const Text('Open Camera'),
        ),
      ),
    );
  }
}
