import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class TeamDetailPage extends StatefulWidget {
  final String teamkey;
  final String teamName;
  final String teamDescription;
  final Future<void> Function() onLeaveTeam;

  const TeamDetailPage({
    super.key,
    required this.teamkey,
    required this.teamName,
    required this.teamDescription,
    required this.onLeaveTeam,
  });

  @override
  _TeamDetailPageState createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  final storage = const FlutterSecureStorage();
  final ImagePicker _picker = ImagePicker();
  bool _isTeamCreator = false;

  @override
  void initState() {
    super.initState();
    _checkIfTeamCreator();
  }

  Future<void> _checkIfTeamCreator() async {
    String? token = await storage.read(key: 'accessToken');
    if (token != null) {
      final response = await http.get(
        Uri.parse('https://server.eco-hero-app.com/v1/teams/${widget.teamkey}/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _isTeamCreator = data['creator'] == 'self'; // Adjust according to your API response structure
        });
      } else {
        print('Error fetching team details: ${response.statusCode}');
      }
    }
  }

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
        request.fields['team_id'] = widget.teamkey;

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
          title: const Text('Scan Result'),
          content: Text('Bin Color: ${result['bin_color']}\nPoints Earned: ${result['points']}'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTeam() async {
    String? token = await storage.read(key: 'accessToken');
    if (token != null) {
      final response = await http.delete(
        Uri.parse('https://server.eco-hero-app.com/v1/teams/${widget.teamkey}/delete/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204) {
        Fluttertoast.showToast(
          msg: "Team deleted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      } else {
        Fluttertoast.showToast(
          msg: "Error deleting team",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
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
              'Team Key: ${widget.teamkey}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: ${widget.teamDescription}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImageForTeamScan(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Scan Trash for Team (3x Points)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await widget.onLeaveTeam();
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Leave Team'),
            ),
            const SizedBox(height: 20),
            if (_isTeamCreator)
              ElevatedButton(
                onPressed: _deleteTeam,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Delete Team'),
              ),
          ],
        ),
      ),
    );
  }
}
