import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../camera/camera_screen_team.dart';

class TeamDetailPage extends StatefulWidget {
  final String teamId;
  final String teamName;
  final String teamDescription;
  final String teamSlug;
  final String teamKey;
  final Function onLeaveTeam;

  const TeamDetailPage({
    Key? key,
    required this.teamId,
    required this.teamName,
    required this.teamDescription,
    required this.teamSlug,
    required this.teamKey,
    required this.onLeaveTeam,
  }) : super(key: key);

  @override
  _TeamDetailPageState createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  final storage = FlutterSecureStorage();
  bool _isLoading = false;

  Future<void> _leaveTeam() async {
    setState(() {
      _isLoading = true;
    });

    String? token;
    try {
      token = await storage.read(key: 'accessToken');
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error accessing secure storage: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('https://server.eco-hero-app.com/v1/teams/${widget.teamId}/leave/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          Fluttertoast.showToast(
            msg: "You have left the team.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          widget.onLeaveTeam(); // Notify parent widget about the team leave
          Navigator.of(context).pop(); // Go back to the previous screen
        } else {
          Fluttertoast.showToast(
            msg: "Failed to leave the team: ${response.body}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "Error: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  void _scanAsTeam() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          isTeamScan: true,
          teamSlug: widget.teamSlug,
          teamKey: widget.teamKey,
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: _isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teamName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.teamDescription,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Team Key: ${widget.teamKey}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Team Slug: ${widget.teamSlug}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  _buildActionButton('Scan as Team', Colors.blue, _scanAsTeam),
                  const SizedBox(height: 10),
                  _buildActionButton('Leave Team', Colors.red, _leaveTeam),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text(
              'Fun Fact',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Every time you recycle, you\'re contributing to a cleaner and greener planet. Keep up the great work!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
