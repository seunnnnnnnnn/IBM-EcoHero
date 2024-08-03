import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../storage_service.dart'; // Import the StorageService

class ScansPage extends StatefulWidget {
  const ScansPage({super.key});

  @override
  _ScansPageState createState() => _ScansPageState();
}

class _ScansPageState extends State<ScansPage> {
  final StorageService storage = StorageService();
  List<dynamic> scans = [];
  bool isLoading = true;
  int limit = 100; // Number of items to load per page
  int offset = 0; // Starting offset
  bool hasMore = true; // Flag to check if more items are available

  @override
  void initState() {
    super.initState();
    fetchScans();
  }

  Future<void> fetchScans() async {
    setState(() {
      isLoading = true;
    });

    try {
      String? token = await storage.read('accessToken');
      if (token != null) {
        final response = await http.get(
          Uri.parse('https://server.eco-hero-app.com/v1/scan/list/?limit=$limit&offset=$offset'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          List<dynamic> newScans = data['results'];
          newScans.sort((a, b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));
          setState(() {
            scans.insertAll(0, newScans); // Insert new scans at the beginning of the list
            offset += limit;
            hasMore = newScans.length == limit; // Check if there are more items to load
          });
        } else {
          print('Error fetching scans: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error fetching scans: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Scans'),
        backgroundColor: Colors.green,
      ),
      body: isLoading && scans.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: scans.length + (hasMore ? 1 : 0), // Add a loader at the end if more items are available
              itemBuilder: (context, index) {
                if (index == scans.length) {
                  // Trigger loading more scans
                  fetchScans();
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final scan = scans[index];
                final meta = scan['meta'];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          meta['image_url'],
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          meta['description'] ?? 'No description',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Bin color: ${meta['color']}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Scanned on: ${scan['created_at']}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
