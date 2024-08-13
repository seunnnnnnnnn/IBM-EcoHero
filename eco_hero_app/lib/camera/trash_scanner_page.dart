// // lib/camera/trash_scanner_page.dart
// import 'package:flutter/material.dart';
// import 'camera_access.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:typed_data';

// class TrashScannerPage extends StatelessWidget {
//   final bool isCommunity;

//   TrashScannerPage({required this.isCommunity});

//   Future<void> _scanTrash(BuildContext context) async {
//     CameraAccess cameraAccess = CameraAccess();
//     Uint8List? imageData = await cameraAccess.pickImage();

//     if (imageData != null) {
//       String apiUrl = 'https://server.eco-hero-app.com/v1/scan/upload/';
//       var headers = {
//         'Authorization': 'Bearer YOUR_API_TOKEN',
//       };

//       var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//       request.files.add(http.MultipartFile.fromBytes('image', imageData, filename: 'scan.jpg'));
//       request.headers.addAll(headers);

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         String responseData = await response.stream.bytesToString();
//         var result = json.decode(responseData);
//         int pointsEarned = isCommunity ? result['points'] * 3 : result['points'];
//         _showScanResult(context, result['bin_color'], pointsEarned);
//       } else {
//         _showError(context, response.reasonPhrase ?? 'Unknown error');
//       }
//     }
//   }

//   void _showScanResult(BuildContext context, String binColor, int pointsEarned) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Scan Result'),
//           content: Text('Bin Color: $binColor\nPoints Earned: $pointsEarned'),
//           actions: [
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop(); // Close the scanner page
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showError(BuildContext context, String error) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Error'),
//           content: Text(error),
//           actions: [
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Scan Trash'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => _scanTrash(context),
//           child: Text('Open Camera'),
//         ),
//       ),
//     );
//   }
// }
