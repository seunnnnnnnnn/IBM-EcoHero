import 'package:flutter/material.dart';

class TeamDetailPage extends StatelessWidget {
  final String teamName;
  final String teamDescription;

  TeamDetailPage({
    required this.teamName,
    required this.teamDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(teamName),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Team Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Team Name: $teamName',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: $teamDescription',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement the quit team functionality
              },
              child: Text('Quit Team'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Team Waste Scans',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // Add a list of waste scans here
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement the scan functionality with double points
              },
              child: Text('Scan Waste (Double Points)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
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
