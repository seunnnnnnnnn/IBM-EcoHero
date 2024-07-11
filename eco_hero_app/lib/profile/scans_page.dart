import 'package:flutter/material.dart';

class ScansPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Scans'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          'Your scans will be displayed here.',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
