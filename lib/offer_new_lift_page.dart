// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class OfferNewLiftPage extends StatefulWidget {
//   const OfferNewLiftPage({Key? key});

//   @override
//   State<OfferNewLiftPage> createState() => _OfferNewLiftPageState();
// }

// class _OfferNewLiftPageState extends State<OfferNewLiftPage> {
//   final TextEditingController departureController = TextEditingController();
//   final TextEditingController destinationController = TextEditingController();
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController timeController = TextEditingController();
//   final TextEditingController seatsController = TextEditingController();

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != DateTime.now()) {
//       dateController.text = DateFormat('yyyy-MM-dd').format(picked);
//     }
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) {
//       timeController.text = picked.format(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Offer a New Lift'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: departureController,
//               decoration: InputDecoration(labelText: 'Departure Place'),
//             ),
//             TextField(
//               controller: destinationController,
//               decoration: InputDecoration(labelText: 'Destination'),
//             ),
//             TextField(
//               controller: dateController,
//               decoration: InputDecoration(labelText: 'Date'),
//               onTap: () => _selectDate(context),
//             ),
//             TextField(
//               controller: timeController,
//               decoration: InputDecoration(labelText: 'Time'),
//               onTap: () => _selectTime(context),
//             ),
//             TextField(
//               controller: seatsController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(labelText: 'Number of Seats'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () async {
//                 final String departure = departureController.text;
//                 final String destination = destinationController.text;
//                 final String date = dateController.text;
//                 final String time = timeController.text;
//                 final int seats = int.tryParse(seatsController.text) ?? 0;

//                 if (departure.isNotEmpty &&
//                     destination.isNotEmpty &&
//                     date.isNotEmpty &&
//                     time.isNotEmpty &&
//                     seats > 0) {
//                   final user = FirebaseAuth.instance.currentUser;
//                   if (user != null) {
//                     final liftsCollection = FirebaseFirestore.instance.collection('lifts');
//                     await liftsCollection.add({
//                       'departurePlace': departure,
//                       'destination': destination,
//                       'date': date,
//                       'time': time,
//                       'seats': seats,
//                       'userId': user.uid,
//                     });

//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('Lift successfully offered!'),
//                         duration: Duration(seconds: 2),
//                       ),
//                     );

//                     Navigator.pop(context);
//                   }
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Please fill in all fields with valid information.'),
//                       duration: Duration(seconds: 2),
//                     ),
//                   );
//                 }
//               },
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
