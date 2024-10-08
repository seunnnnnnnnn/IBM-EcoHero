import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../storage_service.dart'; // Import the StorageService
import 'camera_access.dart';
//import '../widgets/bin_button.dart';
import '../main.dart'; // Import the MainApp for navigation

class CameraScreen extends StatefulWidget {
  final bool isTeamScan; // Add this to differentiate between home and team scans
  final String? teamSlug; // Make teamSlug optional
  final String teamKey; // Add teamKey as a required parameter

  const CameraScreen({
    super.key,
    this.isTeamScan = false,
    this.teamSlug,
    required this.teamKey, // Mark teamKey as required
  });

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

      String url = 'https://server.eco-hero-app.com/v1/scan/upload/?team=${widget.teamKey}';
      // if (isTeamScan && widget.teamSlug != null) {
      //   url += '&team_slug=${widget.teamSlug}';
      // }

      var request = http.MultipartRequest('POST', Uri.parse(url));
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
        print('Response Body: ${responseData.body}');
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
              Text(
                description,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBinButton('Black', Colors.black, binColor, isTeamScan),
                  _buildBinButton('Green', Colors.green, binColor, isTeamScan),
                  _buildBinButton('Blue', Colors.blue, binColor, isTeamScan),
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

  Widget _buildBinButton(String text, Color color, String binColor, bool isTeamScan) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: () => _confirmBinSelection(binColor, text.toLowerCase(), isTeamScan),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _confirmBinSelection(String correctBin, String selectedBin, bool isTeamScan) async {
    String? token = await storage.read('accessToken'); // Read the access token from storage
    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('https://server.eco-hero-app.com/v1/scan/confirm-bin/?team=${widget.teamKey}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({
            'bin_color': correctBin,
            'color': selectedBin,
            'points': isTeamScan ? 3 : 1, // Award 3 points for team scans, 1 for individual scans
          }),
        );

        if (response.statusCode == 200) {
          if (correctBin == selectedBin) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(isTeamScan ? 'Correct! 3 points awarded!' : 'Correct! Points awarded!')),
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
