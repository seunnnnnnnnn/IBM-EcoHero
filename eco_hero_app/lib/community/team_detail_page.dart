import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class TeamDetailPage extends StatefulWidget {
  final String teamId;
  final String teamName;
  final String teamDescription;
  final Future<void> Function() onLeaveTeam;

  const TeamDetailPage({
    Key? key,
    required this.teamId,
    required this.teamName,
    required this.teamDescription,
    required this.onLeaveTeam,
  }) : super(key: key);

  @override
  _TeamDetailPageState createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  final storage = FlutterSecureStorage();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageForTeamScan(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      String? token = await storage.read(key: 'accessToken');
      if (token != null) {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('https://server.eco-hero-app.com/v1/scan/'),
        );
        request.headers['Authorization'] = 'Bearer $token';
        request.files.add(await http.MultipartFile.fromPath('file', pickedFile.path));
        request.fields['team_id'] = widget.teamId;

        final response = await request.send();
        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          final result = json.decode(responseData);
          _showScanResult(context, result);
        } else {
          Fluttertoast.showToast(
            msg: "Error scanning the item.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }
    }
  }

  void _showScanResult(BuildContext context, dynamic result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scan Result'),
          content: Text('Bin Color: ${result['bin_color']}\nPoints Earned: ${result['points']}'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teamName),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Team ID: ${widget.teamId}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: ${widget.teamDescription}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImageForTeamScan(context),
              child: Text('Scan Trash for Team (3x Points)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await widget.onLeaveTeam();
                Navigator.of(context).pop();
              },
              child: Text('Leave Team'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
