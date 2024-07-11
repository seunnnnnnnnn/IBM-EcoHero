import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildNotificationOption(
            context: context,
            title: 'Enable Notifications',
            subtitle: 'Turn notifications on or off',
            value: notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green,
      ),
    );
  }
}
