import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchLiftsPage extends StatefulWidget {
  @override
  _SearchLiftsPageState createState() => _SearchLiftsPageState();
}

class _SearchLiftsPageState extends State<SearchLiftsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Lifts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter destination or other criteria...',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultPage(searchQuery: _searchController.text.trim()),
                  ),
                );
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResultPage extends StatelessWidget {
  final String searchQuery;

  const SearchResultPage({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('lifts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final List<QueryDocumentSnapshot> filteredLifts = snapshot.data!.docs.where((lift) {
            Map<String, dynamic> data = lift.data() as Map<String, dynamic>;
            return data['destination'].toString().contains(searchQuery);
          }).toList();

          if (filteredLifts.isEmpty) {
            return Center(child: Text('No lifts found for the given criteria.'));
          }

          return ListView.builder(
            itemCount: filteredLifts.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data = filteredLifts[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text('Departure: ${data['departure']}'),
                subtitle: Text('Destination: ${data['destination']}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Joining lift: ${data['destination']}'),
                    ));
                  },
                  child: Text('Join'),
                ),
                onTap: () {
                },
              );
            },
          );
        },
      ),
    );
  }
}
