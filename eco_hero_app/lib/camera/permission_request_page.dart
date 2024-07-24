// // lib/camera/permission_request_page.dart
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import '../main.dart';

// class PermissionRequestPage extends StatefulWidget {
//   const PermissionRequestPage({super.key});

//   @override
//   _PermissionRequestPageState createState() => _PermissionRequestPageState();
// }

// class _PermissionRequestPageState extends State<PermissionRequestPage> {
//   @override
//   void initState() {
//     super.initState();
//     _checkPermissions();
//   }

//   Future<void> _checkPermissions() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool permissionsGranted = prefs.getBool('permissions_granted') ?? false;

//     if (permissionsGranted || kIsWeb) {
//       _navigateToMainPage();
//     } else {
//       _requestPermissions();
//     }
//   }

//   Future<void> _requestPermissions() async {
//     bool cameraGranted = await Permission.camera.request().isGranted;
//     bool locationGranted = await Permission.location.request().isGranted;

//     if (cameraGranted && locationGranted) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('permissions_granted', true);
//       _navigateToMainPage();
//     } else {
//       _showPermissionDeniedDialog();
//     }
//   }

//   void _navigateToMainPage() {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => const MainPage()),
//     );
//   }

//   void _showPermissionDeniedDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Permissions Denied'),
//         content: const Text(
//             'The app requires camera and location permissions to function properly. Please grant the permissions in your device settings.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
