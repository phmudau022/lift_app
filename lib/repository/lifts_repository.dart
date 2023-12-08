import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class LiftsRepository {
  var logger = Logger();
  final CollectionReference liftsCollection = FirebaseFirestore.instance.collection('lifts');

  Future<void> createLift({
    required String departurePlace,
    required DateTime departureDateTime,
    required String destination,
    required int availableSeats,
    required String providerName,
  }) async {
    try {
      await liftsCollection.add({
        'departurePlace': departurePlace,
        'departureDateTime': departureDateTime,
        'destination': destination,
        'availableSeats': availableSeats,
        'providerName': providerName,
      });
      logger.d('Lift created successfully');
    } catch (e) {
      logger.e('Error creating lift: $e');
      rethrow;
    }
  }

  Future<void> updateLift(String liftId, {
    String? departurePlace,
    DateTime? departureDateTime,
    String? destination,
    int? availableSeats,
    String? providerName,
  }) async {
    try {
      await liftsCollection.doc(liftId).update({
        if (departurePlace != null) 'departurePlace': departurePlace,
        if (departureDateTime != null) 'departureDateTime': departureDateTime,
        if (destination != null) 'destination': destination,
        if (availableSeats != null) 'availableSeats': availableSeats,
        if (providerName != null) 'providerName': providerName,
      });
      logger.d('Lift updated successfully');
    } catch (e) {
      logger.e('Error updating lift: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getOfferedLifts() async {
    try {
      final liftsSnapshot = await liftsCollection.get();
      return liftsSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      logger.e('Error getting lifts: $e');
      rethrow;
    }
  }
}
