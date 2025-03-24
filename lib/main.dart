import 'package:flutter/material.dart';
import 'signup_login.dart';
import 'signup.dart';
import 'login.dart';
import 'homepage.dart';
import 'day_planner_screen.dart';
import 'expenses.dart';
import 'attendance.dart';
import 'wellness.dart';
import 'package:firebase_core/firebase_core.dart';
import 'profile.dart';
import 'attendance.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      initialRoute: HomePage.id,
      routes: {
        SignupLogin.id: (context) => SignupLogin(),
        SignupPage.id: (context) => SignupPage(),
        LoginPage.id: (context) => LoginPage(),
        HomePage.id: (context) => HomePage(),
        DayPlannerScreen.id: (context) => DayPlannerScreen(),
        ExpensesPage.id: (context) => ExpensesPage(),
        WellnessPage.id: (context) => WellnessPage(),
        StudentProfile.id:(context) => StudentProfile(),
        AttendanceForm.id:(context) => AttendanceForm(),
      },
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
