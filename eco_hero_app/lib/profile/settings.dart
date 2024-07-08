import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SwitchListTile(
              title: Text('Push Notifications'),
              value: true,
              onChanged: (bool value) {
                // Handle switch
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Handle updating profile
              },
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
