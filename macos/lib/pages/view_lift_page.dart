import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lifts App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ViewLiftsPage(),
    );
  }
}

class ViewLiftsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Lifts'),
      ),
      body: LiftsList(),
    );
  }
}

class LiftsList extends StatelessWidget {
  Future<bool?> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to perform this action?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performAction(
    BuildContext context,
    String action, // 'join', 'cancel', or 'delete'
    Map<String, dynamic> data,
  ) async {
    bool? confirmed = await _showConfirmationDialog(context);

    if (confirmed == true) {
      if (action == 'delete') {
        await cancelOfferedLift(context); // Placeholder action
      } else {
        String liftId = data['id']; // Replace 'id' with the actual field name in your Firestore document

        if (action == 'join') {
          await updateLiftStatus(liftId, 'Booked');
        } else if (action == 'cancel') {
          await updateLiftStatus(liftId, 'Available');
        }
      }
    }
  }

  Future<void> updateLiftStatus(String liftId, String newStatus) async {
    // Replace 'status' with the actual field name in your Firestore document
    await FirebaseFirestore.instance.collection('lifts').doc(liftId).update({'status': newStatus});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('lifts').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        return DataTable(
          columns: [
            DataColumn(label: Text('Departure')),
            DataColumn(label: Text('Destination')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Time')),
            DataColumn(label: Text('Seats')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Role')),
            DataColumn(label: Text('Status')), // New column for status
            DataColumn(label: Text('Actions')),
          ],
          rows: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

            // Determine the status based on your logic
            String status = data['status'] ?? 'Available';

            return DataRow(
              cells: [
                DataCell(Text(data['departure'].toString())),
                DataCell(Text(data['destination'].toString())),
                DataCell(Text(DateFormat('yyyy-MM-dd')
                    .format((data['date'] as Timestamp).toDate()))),
                DataCell(Text(data['departureTime'].toString())),
                DataCell(Text(data['seats'].toString())),
                DataCell(Text(data['email'].toString())),
                DataCell(Text(data['role'].toString())),
                DataCell(Text(status)), // Display the status
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          // Add functionality to toggle visibility
                          // You can use a state management solution for this
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () async {
                          await _performAction(context, 'join', data);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel, color: Colors.red),
                        onPressed: () async {
                          await _performAction(context, 'cancel', data);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _performAction(context, 'delete', data);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}

Future<void> cancelOfferedLift(BuildContext context) async {
  // Placeholder for cancelOfferedLift action
  // Implement your logic for canceling the offered lift
}
