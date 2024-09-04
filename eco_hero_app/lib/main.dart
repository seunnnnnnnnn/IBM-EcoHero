import 'package:eco_hero_app/storage_service.dart';
import 'package:eco_hero_app/camera/camera_access.dart'; // Import the CameraAccess class
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home/home_page.dart';
import 'community/community_page.dart';
import 'profile/profile_page.dart';
import 'widgets/common_widgets.dart';
// import 'camera/permission_request_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoHero App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: const PermissionRequestPage(),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final StorageService _storageService = StorageService(); // Initialize StorageService
  final http.Client _httpClient = http.Client(); // Initialize http.Client
  final CameraAccess _cameraAccess = CameraAccess(); // Initialize CameraAccess

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    _pages.add(
      HomePage(
        storageService: _storageService,
        cameraAccess: _cameraAccess, // Pass a valid CameraAccess instance
        httpClient: _httpClient,
      ),
    );
    _pages.add(
      CommunityPage(httpClient: _httpClient,),
    );
    _pages.add(
      ProfilePage(storageService: _storageService, httpClient: _httpClient),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
