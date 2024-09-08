import 'package:flutter/material.dart';
import 'notifications_page.dart';
import 'help_support_page.dart';
import 'your_scans_page.dart';
import 'email_entry_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../storage_service.dart'; // Import the StorageService
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final StorageService storageService;
  final http.Client httpClient;

  const ProfilePage({super.key, required this.storageService, required this.httpClient});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? email;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final storedEmail = await widget.storageService.read('email');
    setState(() {
      email = storedEmail;
    });
  }

  Future<void> _logout() async {
    await widget.storageService.deleteAll();
    setState(() {
      email = null;
    });
    Fluttertoast.showToast(
      msg: "Logged out successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50), // Add padding to avoid notch and status bar
              const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.green,
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 50, color: Colors.green),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      email ?? 'Anonymous user',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email != null ? '@${email!.split('@')[0]}' : '@anonymous',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (email == null)
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 44, 146, 56),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Join EcoHero',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Unlock full potential with a free account.',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EmailEntryPage(
                                      storageService: widget.storageService,
                                      httpClient: widget.httpClient,
                                    ),
                                  ),
                                ).then((_) {
                                  _checkLoginStatus();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Continue with Email'),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    _buildProfileOption(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      subtitle: 'Manage your notifications',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NotificationsPage()),
                        );
                      },
                    ),
                    _buildProfileOption(
                      icon: Icons.help,
                      title: 'Help and support',
                      subtitle: 'Find out more about EcoHero',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HelpSupportPage()),
                        );
                      },
                    ),
                    _buildProfileOption(
                      icon: Icons.history,
                      title: 'Your scans',
                      subtitle: 'Check out your waste scans',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ScansPage()),
                        );
                      },
                    ),
                    if (email != null) const SizedBox(height: 20),
                    if (email != null)
                      ElevatedButton(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Logout'),
                      ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'olu',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
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
}
