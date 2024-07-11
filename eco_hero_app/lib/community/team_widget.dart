import 'package:flutter/material.dart';

class TeamWidget extends StatelessWidget {
  final String teamName;
  final int members;
  final VoidCallback onTap;

  TeamWidget({
    required this.teamName,
    required this.members,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        teamName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Text('Members: $members'),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.green),
      onTap: onTap,
    );
  }
}
