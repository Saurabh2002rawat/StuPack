import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'components/custom_text_card.dart';
import 'day_planner_screen.dart';
import 'expenses.dart';
import 'wellness.dart';
import 'signup_login.dart';
import 'profile.dart';
import 'services/fetchUser.dart';
import 'attendance.dart';

class HomePage extends StatefulWidget {
  static const id = 'HomePage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  String userName = "";
  var loggedInUser;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  void getUserName() async {
    userName = (await AuthHelper.getCurrentUserName())!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    checkUserStatus();
    getUserName();

    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void checkUserStatus() async {
    loggedInUser = _auth.currentUser;
    if (loggedInUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, SignupLogin.id);
      });
    } else {
      print('Logged in user: ${loggedInUser!.email}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF8F9FE),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Daily Thrive",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent,
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<String>(
              offset: Offset(0, 55),
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.1),
                ),
                child: Icon(
                  Icons.person,
                  size: 28.0,
                  color: Colors.blueAccent,
                ),
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    width: 240.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      gradient: LinearGradient(
                        colors: [Color(0xFF4A67FF), Color(0xFF3F8CFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 12.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                FontAwesomeIcons.circleUser,
                                size: 24.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12.0),
                            Flexible(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, StudentProfile.id);
                                },
                                child: Text(
                                  userName,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.white.withOpacity(0.3),
                          thickness: 1,
                          height: 30,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                FontAwesomeIcons.arrowRightFromBracket,
                                size: 22.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12.0),
                            Flexible(
                              child: TextButton(
                                onPressed: () {
                                  _auth.signOut();
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    SignupLogin.id,
                                        (route) => false,
                                  );
                                },
                                child: Text(
                                  'Log Out',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12),
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: FadeTransition(
            opacity: _fadeInAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15.0),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4A67FF), Color(0xFF3F8CFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.format_quote,
                        size: 42,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: DefaultTextStyle(
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.4,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                '"Discipline makes man Perfect"',
                                speed: Duration(milliseconds: 100),
                              ),
                              TypewriterAnimatedText(
                                '"Education is the passport to the future"',
                                speed: Duration(milliseconds: 100),
                              ),
                              TypewriterAnimatedText(
                                '"Knowledge is power"',
                                speed: Duration(milliseconds: 100),
                              ),
                            ],
                            repeatForever: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 35),
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 5,
                      decoration: BoxDecoration(
                        color: Color(0xFF4A67FF),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Student Tools",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2A2E43),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                // First Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    buildAnimatedFeatureCard(
                      title: "Daily Planner",
                      icon: Icons.next_plan,
                      color: Color(0xFF4A67FF),
                      onPressed: () {
                        Navigator.pushNamed(context, DayPlannerScreen.id);
                      },
                    ),
                    buildAnimatedFeatureCard(
                      title: "Track Attendance",
                      icon: Icons.check_circle,
                      color: Color(0xFF3F8CFF),
                      onPressed: () {
                        Navigator.pushNamed(context, AttendanceForm.id);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Second Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    buildAnimatedFeatureCard(
                      title: "Expense Tracking",
                      icon: Icons.account_balance_wallet,
                      color: Color(0xFFFF8748),
                      onPressed: () {
                        Navigator.pushNamed(context, ExpensesPage.id);
                      },
                    ),
                    buildAnimatedFeatureCard(
                      title: "Journal Diary",
                      icon: Icons.spa,
                      color: Color(0xFFFFBB0C),
                      onPressed: () {
                        Navigator.pushNamed(context, WellnessPage.id);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFFE8F1FF),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.tips_and_updates,
                          color: Color(0xFF4A67FF),
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Daily Tip",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2A2E43),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Take short breaks between study sessions to improve retention and focus.",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Color(0xFF7C82A1),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Enhanced Feature Card Widget
  Widget buildAnimatedFeatureCard({
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.43,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                size: 30,
                color: color,
              ),
            ),
            SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2A2E43),
              ),
            ),
            SizedBox(height: 6),
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}