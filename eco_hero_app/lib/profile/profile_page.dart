import 'package:flutter/material.dart';
import 'notifications_page.dart';
import 'help_support_page.dart';
import 'scans_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package: sign_in_button/sign_in_button.dart';
class ProfilePage extends StatelessWidget {
  // Commenting out the AuthService instance as it's not defined
  // final AuthService _authService = AuthService();

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
                    const Text(
                      'Anonymous user',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '@anonymous',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 44, 146, 56),
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
                              try {
                                Fluttertoast.showToast(
                                  msg: "Coming soon!",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.TOP_LEFT,
                                  backgroundColor: Colors.black54,
                                  textColor: Colors.white,
                                );
                              } catch (e) {
                                print("Error showing toast: $e");
                              }
                            },
                            child: const Text('Continue with Email'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 255, 255, 255),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                         // const SizedBox(height: 10),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     // Placeholder for Google sign-in
                          //     try {
                          //       Fluttertoast.showToast(
                          //         msg: "Google sign-in coming soon!",
                          //         toastLength: Toast.LENGTH_SHORT,
                          //         gravity: ToastGravity.BOTTOM,
                          //         backgroundColor: Colors.black54,
                          //         textColor: Colors.white,
                          //       );
                          //     } catch (e) {
                          //       print("Error showing toast: $e");
                          //     }
                          //   },
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.white,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //   ),
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.min,
                          //     children: [
                          //       Icon(
                          //         Icons.google,
                          //         color: Colors.black,
                          //         size: 24.0,
                          //       ),
                          //       const SizedBox(width: 10),
                          //       const Text(
                          //         'Continue with Google',
                          //         style: TextStyle(
                          //           color: Colors.black,
                          //           fontSize: 16,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
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
                          MaterialPageRoute(builder: (context) => NotificationsPage()),
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
                          MaterialPageRoute(builder: (context) => HelpSupportPage()),
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
                          MaterialPageRoute(builder: (context) => ScansPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        '9ja',
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
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.green),
      onTap: onTap,
    );
  }
}
