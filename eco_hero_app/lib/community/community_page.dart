import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import '../profile/email_entry_page.dart';
import 'team_detail_page.dart';
import '../storage_service.dart'; // Import the StorageService

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final StorageService storage = StorageService(); // Use StorageService
  bool _isLoggedIn = false;
  List<dynamic> _teams = [];
  List<dynamic> _individualLeaderboard = [];
  int _points = 0; // Changed from _totalPoints to _points

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    String? token = await storage.read('accessToken');
    if (token != null) {
      if (mounted) {
        setState(() {
          _isLoggedIn = true;
        });
      }
      _fetchData(token);
    } else {
      print('No access token found');
    }
  }

  Future<void> _fetchData(String token) async {
    await Future.wait([
      _fetchTeams(token),
      _fetchIndividualLeaderboard(token),
      _fetchUserStats(token), // Updated to fetch user stats
    ]);
  }

  Future<void> _fetchTeams(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://server.eco-hero-app.com/v1/teams/list/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _teams = data;
          });
        }
      } else {
        print('Error fetching teams: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching teams: $e');
    }
  }

  Future<void> _fetchIndividualLeaderboard(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://server.eco-hero-app.com/v1/leaderboard/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _individualLeaderboard = data;
          });
        }
      } else {
        print('Error fetching individual leaderboard: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching individual leaderboard: $e');
    }
  }

  Future<void> _fetchUserStats(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://server.eco-hero-app.com/v1/scans/user/'), // Use the same endpoint as in HomePage
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _points = data['points']; // Update _points from the response
          });
        }
      } else {
        print('Error fetching user stats: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user stats: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        actions: const [
          Icon(Icons.bookmark, color: Colors.green),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Community',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 20),
              _buildReskyePoint(),
              const SizedBox(height: 20),
              _isLoggedIn ? _buildTeamSection(context) : _buildLoginPrompt(context),
              const SizedBox(height: 20),
              _isLoggedIn ? _buildIndividualLeaderboard() : Container(),
              const SizedBox(height: 20),
              _isLoggedIn ? _buildTeams(context) : Container(),
              const SizedBox(height: 20),
              _buildGrowingTree(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReskyePoint() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Reskye Points',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            Text(
              '$_points Points', // Updated to use _points
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            LinearProgressIndicator(
              value: _points / 50, // Updated to use _points
              backgroundColor: Colors.grey[200],
              color: Colors.green,
              minHeight: 10,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTeamSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create or Join a Team',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _handleCreateTeam(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Create Team'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _handleJoinTeam(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Join Team'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleCreateTeam(BuildContext context) async {
    if (_teams.length >= 4) {
      Fluttertoast.showToast(
        msg: "You have reached the maximum number of teams. Please leave a team before creating a new one.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    _showCreateGroupDialog(context);
  }

  void _handleJoinTeam(BuildContext context) async {
    if (_teams.length >= 4) {
      Fluttertoast.showToast(
        msg: "You have reached the maximum number of teams. Please leave a team before joining a new one.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    _showJoinGroupDialog(context);
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Join the Community',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Sign up or log in to create or join a team and participate in the community.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EmailEntryPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Sign Up / Log In'),
        ),
      ],
    );
  }

  Widget _buildIndividualLeaderboard() {
    return _individualLeaderboard.isEmpty
        ? _buildEmptyLeaderboardMessage()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Individual Leaderboard',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: _individualLeaderboard.map((user) {
                    return ListTile(
                      title: Row(
                        children: [
                          Text(
                            user['email'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${user['points']} pts',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
  }

  Widget _buildEmptyLeaderboardMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'No leaderboard entries found.',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        ElevatedButton(
          onPressed: () => _handleJoinTeam(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Start Scanning!'),
        ),
      ],
    );
  }

  Widget _buildTeams(BuildContext context) {
    return _teams.isEmpty
        ? _buildEmptyTeamMessage()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Teams',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: _teams.map((team) {
                    return Card(
                      child: ListTile(
                        title: Text(team['name']),
                        subtitle: Text(team['description']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeamDetailPage(
                                teamkey: team['key'],
                                teamName: team['name'],
                                teamDescription: team['description'],
                                onLeaveTeam: () async {
                                  String? token = await storage.read('accessToken');
                                  if (token != null) {
                                    try {
                                      final response = await http.post(
                                        Uri.parse('https://server.eco-hero-app.com/v1/teams/${team['id']}/leave/'), //? instead of leave its delete  and pass it {id} as a parameter
                                        headers: {
                                          'Content-Type': 'application/json',
                                          'Authorization': 'Bearer $token',
                                        },
                                      );

                                      if (response.statusCode == 200) {
                                        Fluttertoast.showToast(
                                          msg: "Left team successfully",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                        );
                                        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                                        _fetchTeams(token); // Refresh teams
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "Error leaving team",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                        );
                                      }
                                    } catch (e) {
                                      Fluttertoast.showToast(
                                        msg: "Error leaving team: $e",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
  }

  Widget _buildEmptyTeamMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'No teams found.',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Create or join a team to participate in the community.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _handleJoinTeam(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Join Team'),
        ),
      ],
    );
  }

  Widget _buildGrowingTree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tree',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Icon(
              Icons.eco,
              size: 50,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Group'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Group Name',
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Create'),
              onPressed: () async {
                final String name = nameController.text;
                final String description = descriptionController.text;

                if (name.isEmpty || description.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please fill in all fields",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return;
                }

                String? token = await storage.read('accessToken');
                if (token != null) {
                  try {
                    final response = await http.post(
                      Uri.parse('https://server.eco-hero-app.com/v1/teams/create/'),
                      body: json.encode({'name': name, 'description': description}),
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                    );

                    if (response.statusCode == 201 || response.statusCode == 200) {
                      Fluttertoast.showToast(
                        msg: "Team created successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                      );
                      Navigator.of(context).pop(); // Close the dialog
                      _fetchTeams(token); // Refresh the team list
                    } else {
                      final responseData = json.decode(response.body);
                      Fluttertoast.showToast(
                        msg: "Error creating team: ${responseData['detail']}",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  } catch (e) {
                    Fluttertoast.showToast(
                      msg: "Error creating team: $e",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showJoinGroupDialog(BuildContext context) {
    final TextEditingController codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Join Group'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(
                    labelText: 'Team Key',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Join'),
              onPressed: () async {
                final String teamKey = codeController.text; // Ensure key is collected from UI

                if (teamKey.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please enter the team key",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return;
                }

                String? token = await storage.read('accessToken');
                if (token != null) {
                  try {
                    final response = await http.post(
                      Uri.parse('https://server.eco-hero-app.com/v1/teams/join/?key=$teamKey'), // Correct URL
                      body: json.encode({'key': teamKey}), // Correct key parameter in the body
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                    );

                    if (response.statusCode == 200) {
                      Fluttertoast.showToast(
                        msg: "Joined team successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                      );
                      Navigator.of(context).pop(); // Close the dialog
                      _fetchTeams(token); // Refresh the team list
                    } else {
                      final responseData = json.decode(response.body);
                      Fluttertoast.showToast(
                        msg: "Error joining team: ${responseData['error']}",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  } catch (e) {
                    Fluttertoast.showToast(
                      msg: "Error joining team: $e",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
