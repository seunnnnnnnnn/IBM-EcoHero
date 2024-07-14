import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  bool _isPickingImage = false; // Flag to prevent multiple requests
  bool _isLoggedIn = false;
  String _totalItems = '0';
  String _ibmOffice = '0';
  String _location = 'N/A';
  String _daysCount = '0';
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? token = await storage.read(key: 'accessToken');
    if (token != null) {
      setState(() {
        _isLoggedIn = true;
      });
      _fetchUserStats(token);
    }
  }

  Future<void> _fetchUserStats(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://server.eco-hero-app.com/v1/user/stats/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _totalItems = data['total_items'].toString();
          _ibmOffice = data['ibm_office'].toString();
          _location = data['location'].toString();
          _daysCount = data['days_count'].toString();
        });
      } else {
        print('Error fetching stats: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching stats: $e');
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    if (_isPickingImage) return;

    setState(() {
      _isPickingImage = true;
    });

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        // Send the image to the server for analysis
        await _analyzeImage(pickedFile);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No image captured.')),
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

  Future<void> _analyzeImage(XFile imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://server.eco-hero-app.com/v1/analyze'),
      );
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final data = json.decode(responseData.body);
        final binColor = data['bin_color'];
        // Display the bin color to the user
        await _showBinColorDialog(binColor);
      } else {
        print('Error analyzing image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error analyzing image: $e');
    }
  }

  Future<void> _showBinColorDialog(String binColor) async {
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

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bin Color'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('The bin color for this item is $binColor.'),
              ],
            ),
          ),
          backgroundColor: dialogColor,
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                if (_isLoggedIn) {
                  _confirmBinSelection(binColor);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmBinSelection(String binColor) async {
    // Assuming the user selects the correct bin
    // If the user is logged in, award points
    String? token = await storage.read(key: 'accessToken');
    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('https://server.eco-hero-app.com/v1/confirm-bin'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({'bin_color': binColor}),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Points awarded!')),
          );
          _fetchUserStats(token);
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
                    onTap: () => _pickImage(context),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 44, 146, 56).withOpacity(0.8),
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
                  _buildStatsList(),
                  const SizedBox(height: 40),
                  const Text(
                    'Learn more about EcoHero!',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildWhyEcoHeroButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsList() {
    return Column(
      children: [
        _buildStatCard('Total Items this month', _totalItems, const Color.fromARGB(255, 0, 0, 0)),
        const SizedBox(height: 10),
        _buildStatCard('IBM Office Rank', _ibmOffice, const Color.fromARGB(255, 0, 0, 0)),
        const SizedBox(height: 10),
        _buildStatCard('Location', _location, const Color.fromARGB(255, 0, 0, 0)),
        const SizedBox(height: 10),
        _buildStatCard('Days Count', _daysCount, const Color.fromARGB(255, 0, 0, 0)),
      ],
    );
  }

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

  Widget _buildWhyEcoHeroButton() {
    return GestureDetector(
      onTap: () async {
        const url = 'https://www.recyclenow.com/how-to-recycle/why-is-recycling-important'; // Replace with the actual URL
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
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
            'Why EcoHero?',
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
