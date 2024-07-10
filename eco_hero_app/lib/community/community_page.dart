import 'package:flutter/material.dart';

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
              _buildTeamSection(),
              const SizedBox(height: 20),
              _buildLeaderboard(),
              const SizedBox(height: 20),
              _buildTeams(),
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
        const Text(
          'Reskye Points',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0), // Set the text color to green
          ),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: 0.7, // Example value
          backgroundColor: Colors.grey[200],
          color: Colors.green, // Set the progress indicator color to green
          minHeight: 10,
        ),
      ],
    );
  }

  Widget _buildTeamSection() {
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
                onPressed: () {},
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
                onPressed: () {},
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

  Widget _buildTeams() {
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
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Team ${index + 1}'),
                  Text('Members: ${(index + 1) * 5}'),
                ],
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
          'Your Tree',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0), // Set the text color to green
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/logo.png', // Ensure this image exists in your assets
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
