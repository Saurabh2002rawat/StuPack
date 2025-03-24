import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AuthHelper {
  static String? getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  static Future<String?> getCurrentUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      // Access Firestore document: users → {uid} → profile → personal_info
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('profile')
          .doc('personal_info')
          .get();

      if (doc.exists && doc.data() != null) {
        return doc.data()!['name']; // Make sure 'name' field exists
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user name: $e');
      return null;
    }
  }

  static Future<String?> getCurrentEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      // Access Firestore document: users → {uid} → profile → personal_info
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('profile')
          .doc('personal_info')
          .get();

      if (doc.exists && doc.data() != null) {
        return doc.data()!['email']; // Make sure 'name' field exists
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user name: $e');
      return null;
    }
  }

  static Future<String?> getCurrentUserPhone() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      // Access Firestore document: users → {uid} → profile → personal_info
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('profile')
          .doc('personal_info')
          .get();

      if (doc.exists && doc.data() != null) {
        return doc.data()!['phone']; // Make sure 'name' field exists
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user name: $e');
      return null;
    }
  }


  static Future<String?> getCurrentUserCourse() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      // Access Firestore document: users → {uid} → profile → personal_info
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('profile')
          .doc('personal_info')
          .get();

      if (doc.exists && doc.data() != null) {
        return doc.data()!['course']; // Make sure 'name' field exists
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user name: $e');
      return null;
    }
  }
}
