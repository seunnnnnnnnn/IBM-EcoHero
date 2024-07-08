// This file can be used for managing teams (creating, joining, etc.)
// lib/community/team_management.dart

import 'package:flutter/material.dart';

class TeamManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Management'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Create Team'),
              onPressed: () {
                // Functionality to create a team
              },
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Join Team',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              child: Text('Join'),
              onPressed: () {
                // Functionality to join a team
              },
            ),
          ],
        ),
      ),
    );
  }
}
