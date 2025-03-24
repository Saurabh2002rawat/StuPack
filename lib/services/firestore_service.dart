import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile(String uid, Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('profile')
        .doc('personal_info')
        .set(data);
  }

  Future<void> addDailyPlannerEntry(String uid, Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('daily_planner')
        .add(data);
  }

  Future<void> addHabitTrackerEntry(String uid, Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('habit_tracker')
        .add(data);
  }

  Future<void> addExpenseEntry(String uid, Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .add(data);
  }

  Future<void> addWellnessEntry(String uid, Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('wellness')
        .add(data);
  }
}
