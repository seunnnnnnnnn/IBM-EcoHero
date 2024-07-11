import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'team_detail_page.dart';
import 'team_widget.dart';

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Set the background color to green
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
                  color: Color.fromARGB(255, 0, 0, 0), // Set the text color to green
                ),
              ),
              const SizedBox(height: 20),
              _buildReskyePoint(),
              const SizedBox(height: 20),
              _buildTeamSection(context),
              const SizedBox(height: 20),
              _buildLeaderboard(),
              const SizedBox(height: 20),
              _buildTeams(context),
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
      const Row(
        children: [
          Text(
            'Reskye Points',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0), // Set the text color to green
            ),
          ),
          SizedBox(width: 10),
          Text(
            '----------------8500 Points', // Example value
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Set the text color to black
              //posititon: TextPosition.right, // Align the text to the right
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Stack(
        children: [
          LinearProgressIndicator(
            value: 0.7, // Example value
            backgroundColor: Colors.grey[200],
            color: Colors.green, // Set the progress indicator color to green
            minHeight: 10,
          ),
          //const Center(
            //child: Text(
              //'700 Points', // Example value
              //style: TextStyle(
                //color: Colors.black,
                //fontWeight: FontWeight.bold,
             // ),
           // ),
         // ),
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
            color: Color.fromARGB(255, 0, 0, 0), // Set the text color to green
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showCreateGroupDialog(context),
                child: const Text('Create Team'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Set the button background color to green
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showJoinGroupDialog(context),
                child: const Text('Join Team'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Set the button background color to green
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLeaderboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Leaderboard',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0), // Set the text color to green
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
            children: List.generate(5, (index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Team ${index + 1}'),
                  Text('${(index + 1) * 1000} pts'),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildTeams(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Teams',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0), // Set the text color to green
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
            children: List.generate(5, (index) {
              return TeamWidget(
                teamName: 'Team ${index + 1}',
                members: (index + 1) * 5,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeamDetailPage(
                        teamName: 'Team ${index + 1}',
                        teamDescription: 'Description of Team ${index + 1}',
                      ),
                    ),
                  );
                },
              );
            }),
          ),
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
            color: Color.fromARGB(255, 0, 0, 0), // Set the text color to green
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Icon(
              Icons.eco, // Replace with your desired icon
              size: 50,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Group'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Group Name',
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Create'),
              onPressed: () {
                // Implement create group functionality
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showJoinGroupDialog(BuildContext context) {
    final TextEditingController _codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Join Group'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: 'Group Code',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Join'),
              onPressed: () {
                // Implement join group functionality
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
