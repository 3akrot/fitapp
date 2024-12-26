// lib/database.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthapp/food_track_task.dart';
import 'package:healthapp/models/health_data.dart';

class DatabaseService {
  final String uid;
  final DateTime currentDate;
  
  DatabaseService({required this.uid, required this.currentDate});
  
  final DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final DateTime weekStart = DateTime(2020, 09, 07);

  // User-specific collection references
  final CollectionReference userFoodTrackCollection =
      FirebaseFirestore.instance.collection('users');
  
  // Add the health data collection for step counts
  final CollectionReference userHealthDataCollection =
      FirebaseFirestore.instance.collection('users');

  // Method to add food track entry for a specific user
  Future addFoodTrackEntry(FoodTrackTask food) async {
    return await userFoodTrackCollection
        .doc(uid) // Use the user's UID as the document ID
        .collection('foodTracks') // Create a subcollection for food tracks
        .doc(food.createdOn.millisecondsSinceEpoch.toString()) // Unique document for the food entry
        .set({
      'food_name': food.food_name,
      'calories': food.calories,
      'carbs': food.carbs,
      'fat': food.fat,
      'protein': food.protein,
      'mealTime': food.mealTime,
      'createdOn': food.createdOn,
      'grams': food.grams
    });
  }

  // Method to delete food track entry for a specific user
  Future deleteFoodTrackEntry(FoodTrackTask deleteEntry) async {
    print(deleteEntry.toString());
    return await userFoodTrackCollection
        .doc(uid) // Ensure you're working with the correct user document
        .collection('foodTracks')
        .doc(deleteEntry.createdOn.millisecondsSinceEpoch.toString())
        .delete();
  }

  // Parse the food track entries from Firestore snapshot
  List<FoodTrackTask> _scanListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return FoodTrackTask(
        id: doc.id,
        food_name: doc['food_name'] ?? '',
        calories: doc['calories'] ?? 0,
        carbs: doc['carbs'] ?? 0,
        fat: doc['fat'] ?? 0,
        protein: doc['protein'] ?? 0,
        mealTime: doc['mealTime'] ?? "",
        createdOn: doc['createdOn'].toDate() ?? DateTime.now(),
        grams: doc['grams'] ?? 0,
      );
    }).toList();
  }

  // Stream to get food tracks for the specific user
  Stream<List<FoodTrackTask>> get foodTracks {
    return userFoodTrackCollection
        .doc(uid) // Access the user's document
        .collection('foodTracks') // Get the foodTracks subcollection
        .snapshots()
        .map(_scanListFromSnapshot);
  }

  // Method to get all food track data for a specific user
  Future<List<dynamic>> getAllFoodTrackData() async {
    QuerySnapshot snapshot = await userFoodTrackCollection
        .doc(uid)
        .collection('foodTracks')
        .get();
    List<dynamic> result = snapshot.docs.map((doc) => doc.data()).toList();
    return result;
  }

  // Method to get a single food track data by user ID
  Future<String> getFoodTrackData(String uid) async {
    DocumentSnapshot snapshot = await userFoodTrackCollection.doc(uid).get();
    return snapshot.toString();
  }

  // Method to add step data for a user
  Future<void> addStepData(DateTime date, int steps) async {
    try {
      await userHealthDataCollection
          .doc(uid) // Use the user's UID as the document ID
          .collection('stepCounts') // Create a subcollection for step counts
          .doc(date.millisecondsSinceEpoch.toString()) // Use date as a unique ID
          .set({
        'date': date,
        'steps': steps,
      });
    } catch (e) {
      print('Error saving step data: $e');
    }
  }

  // Method to get step data from Firebase
  Future<List<StepCountData>> getStepData() async {
    try {
      QuerySnapshot snapshot = await userHealthDataCollection
          .doc(uid)
          .collection('stepCounts')
          .get();

      return snapshot.docs.map((doc) {
        return StepCountData(
          doc['date'].toDate(),
          doc['steps'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching step data: $e');
      return [];
    }
  }
}
