import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(EcoHeroApp(camera: firstCamera));
}

class EcoHeroApp extends StatelessWidget {
  final CameraDescription camera;

  const EcoHeroApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(camera: camera),
      theme: ThemeData(
        primaryColor: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final CameraDescription camera;

  const HomePage({super.key, required this.camera});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  XFile? _image;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraScreen(camera: widget.camera)),
    );

    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = _buildHomePage(context);
        break;
      case 1:
        page = CommunityPage();
        break;
      case 2:
        page = _buildProfilePage(context); // Placeholder for the Profile page
        break;
      default:
        page = _buildHomePage(context);
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0), // Adjust height to make it bigger
        child: AppBar(
          backgroundColor: Colors.green,
          flexibleSpace: Container(
            padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 16.0),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  'EcoHero',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomePage(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20), // Add some space below the AppBar
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _pickImage,
                child: const Text(
                  'Trash scanner',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Your stats',
              style: TextStyle(fontSize: 20, color: Colors.green[900]),
            ),
            const SizedBox(height: 10),
            Container(
              height: 200,
              color: Colors.grey[200],
              child: Center(
                child: _image == null
                    ? const Text(
                        'Stats will be displayed here',
                        style: TextStyle(color: Colors.grey),
                      )
                    : Image.file(File(_image!.path)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePage(BuildContext context) {
    // Placeholder for the Profile page
    return const Center(
      child: Text('Profile Page'),
    );
  }
}

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: const Text('Community Page'),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({super.key, required this.camera});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      Navigator.pop(context, image);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.camera),
      ),
    );
  }
}
