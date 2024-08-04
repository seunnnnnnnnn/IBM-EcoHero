import 'package:eco_hero_app/camera/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../camera/camera_access.dart';
import '../widgets/bin_button.dart';
import '../profile/email_entry_page.dart'; // Ensure this is imported
import '../storage_service.dart'; // Import the StorageService

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _isPickingImage = false; // Flag to prevent multiple requests
  String _monthlyScans = '0';
  String _totalScans = '0';
  String _teams = '0';
  String _points = '0';
  String _ranking = '0';
  bool _isLoggedIn = false; // Flag to check if the user is logged in
  final StorageService storage = StorageService(); // Use StorageService

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check login status when the widget initializes
  }

  // Method to check the login status of the user
  Future<void> _checkLoginStatus() async {
    String? token = await storage.read('accessToken'); // Read the access token from storage
    if (token != null) {
      setState(() {
        _isLoggedIn = true;
      });
      _fetchUserStats(token); // Fetch user statistics if logged in
    } else {
      setState(() {
        _isLoggedIn = false;
        _resetStats(); // Reset stats if not logged in
      });
    }
  }

  // Method to fetch user statistics from the server
  Future<void> _fetchUserStats(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://server.eco-hero-app.com/v1/scans/user/'), // URL to fetch user stats
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body); // Decode the response body
        if (mounted) {
          setState(() {
            _monthlyScans = data['monthly_scans'].toString(); // Update monthly scans
            _totalScans = data['total_scans'].toString(); // Update total scans
            _teams = data['teams'].toString(); // Update teams count
            _points = data['points'].toString(); // Update points
            _ranking = data['ranking'].toString(); // Update ranking
          });
        }
      } else {
        // Handle error
        setState(() {
          _resetStats(); // Reset stats on error
        });
      }
    } catch (e) {
      // Handle error
      setState(() {
        _resetStats(); // Reset stats on error
      });
    }
  }

  // Method to reset stats to zero
  void _resetStats() {
    _monthlyScans = '0';
    _totalScans = '0';
    _teams = '0';
    _points = '0';
    _ranking = '0';
  }

  // Method to pick an image using the camera
  Future<void> _pickImage(BuildContext context) async {
    if (_isPickingImage) return;

    setState(() {
      _isPickingImage = true; // Set flag to true to prevent multiple requests
    });

    try {
      CameraAccess cameraAccess = CameraAccess(); // Create an instance of CameraAccess
      Uint8List? imageData = await cameraAccess.pickImage(); // Pick an image and get the data

      if (imageData != null) {
        // Send the image to the server for analysis
        await _analyzeImage(imageData); // Analyze the image
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image captured.')), // Show a snackbar if no image was captured
        );
      }
    } catch (e) {
      // Handle error
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')), // Show a snackbar for errors
      );
    } finally {
      setState(() {
        _isPickingImage = false; // Reset the flag
      });
    }
  }

  // Method to send the image to the server for analysis
  Future<void> _analyzeImage(Uint8List imageData) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://server.eco-hero-app.com/v1/analyze'), // URL to analyze the image
      );
      request.files.add(http.MultipartFile.fromBytes('image', imageData, filename: 'scan.jpg')); // Add the image file to the request
      final response = await request.send(); // Send the request

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response); // Get the response data
        final data = json.decode(responseData.body); // Decode the response data
        final binColor = data['bin_color']; // Get the bin color from the response
        final itemName = data['item_name']; // Get the item name from the response
        // Display the bin color to the user
        if (mounted) await _showBinColorDialog(binColor, itemName); // Show the bin color dialog
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    }
  }

  // Method to show the bin color dialog
  Future<void> _showBinColorDialog(String binColor, String itemName) async {
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

    if (!mounted) return; // Ensure the widget is still mounted

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bin Color'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'The item "$itemName" should go into the $binColor bin.',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ), // Show item name and bin color
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BinButton('Black', Colors.black, binColor, _confirmBinSelection), // Button for black bin
                  BinButton('Green', Colors.green, binColor, _confirmBinSelection), // Button for green bin
                  BinButton('Blue', Colors.blue, binColor, _confirmBinSelection), // Button for blue bin
                ],
              ),
            ],
          ),
          backgroundColor: dialogColor, // Set the dialog background color
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Method to confirm the bin selection
  Future<void> _confirmBinSelection(String binColor, String selectedBin) async {
    String? token = await storage.read('accessToken'); // Read the access token from storage
    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('https://server.eco-hero-app.com/v1/confirm-bin'), // URL to confirm bin selection
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({'bin_color': selectedBin}), // Send the selected bin color
        );

        if (response.statusCode == 200) {
          if (!mounted) return;
          if (binColor == selectedBin) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Correct! Points awarded!')), // Show success message if bin selection is correct
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Incorrect bin. Try again!')), // Show error message if bin selection is incorrect
            );
          }
          Navigator.of(context).popUntil((route) => route.isFirst); // Navigate back to the home screen
          _fetchUserStats(token); // Update user stats after confirming bin selection
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              // image: DecorationImage(
              // image: AssetImage('assets/images/logo.png'), // Replace with the path to your background image
              // fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50), // Add padding to avoid notch and status bar
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'EcoHero',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      if (_isLoggedIn) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CameraScreen(teamSlug: '', teamKey: '',)), // Navigate to CameraScreen
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please log in to use the camera.')), // Show login prompt
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 44, 146, 56).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.camera_alt, color: Color.fromARGB(255, 255, 255, 255)),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Scan your trash',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 246, 246, 246),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Scanner',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 255, 255, 255)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your stats',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildStatsList(), // Build the stats list
                  const SizedBox(height: 40),
                  const Text(
                    'Bonus!',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildWhyEcoHeroButton(), // Build the "Why EcoHero" button
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to build the stats list
  Widget _buildStatsList() {
    return Column(
      children: [
        _buildStatCard('Total items scanned this month', _monthlyScans, const Color.fromARGB(255, 0, 0, 0)),
        const SizedBox(height: 15),
        _buildStatCard('Total scans', _totalScans, const Color.fromARGB(255, 0, 0, 0)),
        const SizedBox(height: 15),
        _buildStatCard('Teams', _teams, const Color.fromARGB(255, 0, 0, 0)),
        const SizedBox(height: 15),
        _buildStatCard('Points', _points, const Color.fromARGB(255, 0, 0, 0)),
        const SizedBox(height: 15),
        _buildStatCard('Ranking', _ranking, const Color.fromARGB(255, 0, 0, 0)),
      ],
    );
  }

  // Method to build a stat card
  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // Method to build the "Why EcoHero" button
  Widget _buildWhyEcoHeroButton() {
    return GestureDetector(
      onTap: () async {
        const url = 'https://www.recyclenow.com/how-to-recycle/why-is-recycling-important'; // Replace with actual URL
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url)); // Launch the URL
        } else {
          throw 'Could not launch $url'; // Throw an error if the URL cannot be launched
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            'Why recycling is important?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
