import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/fetchUser.dart';

class StudentProfile extends StatefulWidget {
  static const id = 'StudentProfile';

  const StudentProfile({super.key});

  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();

  void _showChangePasswordDialog() {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();




    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Current Password'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'New Password'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newPasswordController.text == confirmPasswordController.text) {
                  // Handle password change logic here
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password changed successfully')),
                  );
                } else {
                  // Show error if passwords do not match
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  String userName="";
  String userEmail="";
  String userPhone="";
  String userCourse="";
  String userSemester="";

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    phoneController.dispose();
    courseController.dispose();
    semesterController.dispose();
    super.dispose();
  }

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
    getCurrentUserPhone();
    getCurrentEmail();
    getCurrentUserCourse();
  }
  void getUserName() async {
    userName = (await AuthHelper.getCurrentUserName())!;
    setState(() {

    });
  }
  void getCurrentEmail() async {
    userEmail = (await AuthHelper.getCurrentEmail())!;
    setState(() {

    });
  }
  void getCurrentUserPhone() async {
    userPhone = (await AuthHelper.getCurrentUserPhone())!;
    setState(() {

    });
  }

  void getCurrentUserCourse() async {
    userCourse = (await AuthHelper.getCurrentUserCourse())!;
    setState(() {

    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildRow('Name', userName, isEditable: false),
            _buildRow('Email', userEmail, isEditable: false),
            _buildRow('Phone No.', userPhone, isEditable: false),
            _buildRow('Course', userCourse,  isEditable: false),
            _buildRow('Semester', 'II', isEditable: false),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: _showChangePasswordDialog,
                child: const Text('Change Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isEditable = true, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 50), // Black space in front
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          const SizedBox(width: 20),
          isEditable
              ? Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0), // Adjust height
              ),
            ),
          )
              : Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
