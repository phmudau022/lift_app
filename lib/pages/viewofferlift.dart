import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifts_app/model/lift.dart';

class LiftsViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Lift> lifts = [];

  Future<void> createLift({
    required String departurePlace,
    required String destination,
    required String date,
    required String time,
    required int seats,
  }) async {
    try {
      // Create a new Lift object
      Lift newLift = Lift(
        departurePlace: departurePlace,
        destination: destination,
        date: date,
        time: time,
        seats: seats,
      );

      // Save the new lift to Firebase Firestore
      await _firestore.collection('lifts').add({
        'departurePlace': newLift.departurePlace,
        'destination': newLift.destination,
        'date': newLift.date,
        'time': newLift.time,
        'seats': newLift.seats,
      });

      // Notify listeners that the lift has been created
      notifyListeners();
    } catch (e) {
      print('Error creating lift: $e');
    }
  }

  Future<void> fetchAllLifts() async {
    try {
      // Fetch all lifts from Firebase Firestore
      var liftsSnapshot = await _firestore.collection('lifts').get();

      // Clear existing lifts
      lifts.clear();

      // Convert each document to a Lift object and add to the list
      for (var liftDoc in liftsSnapshot.docs) {
        Map<String, dynamic> liftData = liftDoc.data() as Map<String, dynamic>;
        Lift lift = Lift(
          departurePlace: liftData['departurePlace'],
          destination: liftData['destination'],
          date: liftData['date'],
          time: liftData['time'],
          seats: liftData['seats'],
        );
        lifts.add(lift);
      }

      // Notify listeners that lifts have been fetched
      notifyListeners();
    } catch (e) {
      print('Error fetching lifts: $e');
    }
  }
}
