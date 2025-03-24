import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/to_do_list_card.dart';
import 'services/fetchUser.dart';

class DayPlannerScreen extends StatefulWidget {
  static const id = 'DayPlannerScreen';
  const DayPlannerScreen({super.key});

  @override
  State<DayPlannerScreen> createState() => _DayPlannerScreenState();
}

class _DayPlannerScreenState extends State<DayPlannerScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String new_task = "";
  String userName = "";

  void getUserName() async {
    userName = (await AuthHelper.getCurrentUserName())!;
    setState(() {

    });
  }

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  /// Reference to the user's daily_planner subcollection
  CollectionReference<Map<String, dynamic>> getUserDailyPlannerCollection() {
    final uid = AuthHelper.getCurrentUserId();
    return _firestore.collection('users').doc(uid).collection('daily_planner');
  }

  void _addNewTask() async {
    if (new_task.isEmpty) return;

    await getUserDailyPlannerCollection().add({
      'task': new_task,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      new_task = "";
    });
  }

  void _deleteTask(String docId) async {
    await getUserDailyPlannerCollection().doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: SizedBox(
          width: 60.0,
          height: 60.0,
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Add Task'),
                    content: SizedBox(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Enter your task',
                          hintText: 'Type here...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onChanged: (value) {
                          new_task = value;
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          size: 30.0,
                          color: Colors.redAccent,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (new_task.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a new task'),
                              ),
                            );
                            return;
                          }
                          _addNewTask();
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.check,
                          size: 30.0,
                          color: Colors.lightGreen,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            backgroundColor: Colors.orangeAccent,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 35.0),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  "Day Planner",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              height: 200.0,
              width: double.infinity,
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Hi! $userName",
                    style: TextStyle(
                      fontSize: 40.0,
                      fontFamily: 'RobotoMedium',
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Get Going Let's Do it!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Divider(
              indent: 150,
              endIndent: 150.0,
              color: Colors.orangeAccent,
              thickness: 2.0,
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0),
              padding: EdgeInsets.all(10.0),
              child: Text(
                "TODAY'S TASK",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'sans',
                  fontSize: 17.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: getUserDailyPlannerCollection()
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final tasks = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      var taskText = tasks[index]['task'];
                      var docId = tasks[index].id;
                      return ListTile(
                        title: ToDoListCard(text: taskText),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            _deleteTask(docId);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
