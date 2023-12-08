import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifts_app/pages/create_lift_page.dart';
import 'package:lifts_app/pages/view_lift_page.dart';
import 'package:lifts_app/pages/search_page.dart';

class HomePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SUPERRIDES'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            if (user != null)
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                ),
                child: Text(
                  "Signed in as: ${user?.email!}",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ListTile(
              title: Text('Sign Out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
            ListTile(
              title: Text('Create Lift'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LiftPage(showLoginPage: () {}),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('View Lifts'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewLiftsPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Search Lifts'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchLiftsPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('About Us'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('About Us'),
                      content: Text(
                        'Welcome to SUPERRIDES!\n\n'
                        'At SUPERRIDES, we believe in creating connections and '
                        'making your ridesharing experience memorable. Our community-driven '
                        'platform is designed to ensure safety, convenience, and a pleasant '
                        'journey for everyone involved.\n\n'
                        'Thank you for choosing SUPERRIDES for your travel needs!'
                        '\n\nConnecting People, Creating Memories!',
                        style: TextStyle(fontSize: 16),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to SUPERRIDES!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Connecting People, Creating Memories',
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Additional widgets can be added here as needed.
            Text(
              'Recent Rides',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            // Add a list of recent rides here

            SizedBox(height: 20),
            Text(
              'Featured Destinations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            // Add a list of featured destinations here

            SizedBox(height: 20),
            Text(
              'User Recommendations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            // Add a list of user recommendations here
          ],
        ),
      ),
    );
  }
}
