// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help and Support'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSupportOption(
            context: context,
            icon: Icons.email,
            title: 'Contact Us via Email',
            subtitle: 'Send us an email for support',
            onTap: () {
              _launchEmail('oluwaseun.ayeg@gmail.com');
            },
          ),
          _buildSupportOption(
            context: context,
            icon: Icons.web,
            title: 'Visit Our Website',
            subtitle: 'Get more information on our website',
            onTap: () {
              _launchURL('https://www.ecohero.com');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.green),
      onTap: onTap,
    );
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    final String emailUrl = emailUri.toString();

    // ignore: duplicate_ignore
    // ignore: deprecated_member_use
    if (await canLaunch(emailUrl)) {
      await launch(emailUrl);
    } else {
      throw 'Could not launch $emailUrl';
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
