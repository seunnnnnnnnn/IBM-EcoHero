import 'package:flutter/material.dart';

class TeamWidget extends StatelessWidget {
  final String teamName;
  final int members;
  final VoidCallback onTap;

  const TeamWidget({super.key, 
    required this.teamName,
    required this.members,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        teamName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Text('Members: $members'),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.green),
      onTap: onTap,
    );
  }
}
