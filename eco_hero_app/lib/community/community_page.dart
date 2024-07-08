import 'package:flutter/material.dart';
import 'team_management.dart';
import '../widgets/reskey_points_bar.dart';
import '../widgets/tree_growth.dart';

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reskey Points',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ReskeyPointsBar(),
            SizedBox(height: 20),
            Text(
              'Create Team',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Team Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Handle create team
                  },
                  child: Text('Join Team'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Leaderboard',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 200,
              color: Colors.grey[200],
              child: Center(
                child: Text('Leaderboard will be displayed here'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Teams',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 200,
              color: Colors.grey[200],
              child: Center(
                child: Text('Teams will be displayed here'),
              ),
            ),
            SizedBox(height: 20),
            TreeGrowth(),
          ],
        ),
      ),
    );
  }
}
