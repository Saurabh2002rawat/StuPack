import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class WellnessPage extends StatefulWidget {
  static const id = 'JournalScreen';
  @override
  _WellnessPageState createState() => _WellnessPageState();
}

class _WellnessPageState extends State<WellnessPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
  }

  void _showJournalDialog({String? entryId, String? initialText}) {
    TextEditingController journalController =
        TextEditingController(text: initialText);
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(entryId == null ? "New Journal Entry" : "Edit Journal Entry"),
        content: TextField(
          controller: journalController,
          maxLines: 5,
          decoration: InputDecoration(hintText: "Write your thoughts here..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (journalController.text.trim().isEmpty) return;
              if (entryId == null) {
                _addJournalEntry(date, journalController.text.trim());
              } else {
                _updateJournalEntry(entryId, journalController.text.trim());
              }
              Navigator.pop(context);
            },
            child: Text(entryId == null ? "Add" : "Update"),
          ),
        ],
      ),
    );
  }

  Future<void> _addJournalEntry(String date, String text) async {
    await _firestore
        .collection("users")
        .doc(currentUser?.uid)
        .collection("journal")
        .add({
      "date": date,
      "entry": text,
      "timestamp": FieldValue.serverTimestamp()
    });
  }

  Future<void> _updateJournalEntry(String entryId, String newText) async {
    await _firestore
        .collection("users")
        .doc(currentUser?.uid)
        .collection("journal")
        .doc(entryId)
        .update({"entry": newText});
  }

  Future<void> _deleteJournalEntry(String entryId) async {
    await _firestore
        .collection("users")
        .doc(currentUser?.uid)
        .collection("journal")
        .doc(entryId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daily Journal")),
      body: StreamBuilder(
        stream: _firestore
            .collection("users")
            .doc(currentUser?.uid)
            .collection("journal")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var journalEntries = snapshot.data!.docs;
          Map<String, List<DocumentSnapshot>> groupedEntries = {};
          for (var entry in journalEntries) {
            String date = entry["date"];
            groupedEntries[date] = (groupedEntries[date] ?? [])..add(entry);
          }

          return ListView(
            children: groupedEntries.entries.map((dateGroup) {
              return Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ExpansionTile(
                  title: Text(dateGroup.key,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  children: dateGroup.value.map((entry) {
                    return ListTile(
                      title: Text(entry["entry"]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showJournalDialog(
                                entryId: entry.id, initialText: entry["entry"]),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteJournalEntry(entry.id),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showJournalDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
