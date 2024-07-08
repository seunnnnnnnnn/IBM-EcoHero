import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home/home_page.dart';
import 'community/community_page.dart';
import 'profile/profile_page.dart';

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
