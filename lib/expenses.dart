import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Expenses_Table.dart';

class ExpensesPage extends StatefulWidget {
  static const id = 'ExpensesPage';
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
  }

  Widget _buildCategoryRow(
      Map<String, double> categoryTotals, double totalAmount) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: categoryTotals.entries.map((entry) {
            Color categoryColor = Colors.primaries[
                categoryTotals.keys.toList().indexOf(entry.key) %
                    Colors.primaries.length];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: categoryColor,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '${entry.key}: ${(entry.value / totalAmount * 100).toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expenses')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: StreamBuilder(
              stream: _firestore
                  .collection("users")
                  .doc(currentUser?.uid)
                  .collection("expenses")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                // Declare variables outside
                Map<String, double> categoryTotals = {};
                double totalAmount = 0;

                for (var doc in snapshot.data!.docs) {
                  String category = doc["category"];
                  double amount = double.parse(doc["amount"]);
                  categoryTotals[category] =
                      (categoryTotals[category] ?? 0) + amount;
                  totalAmount += amount;
                }

                List<PieChartSectionData> sections = categoryTotals.entries
                    .map((entry) => PieChartSectionData(
                          value: (entry.value / totalAmount) * 100,
                          title: '',
                          color: Colors.primaries[
                              categoryTotals.keys.toList().indexOf(entry.key) %
                                  Colors.primaries.length],
                        ))
                    .toList();

                if (sections.isEmpty) {
                  sections.add(
                    PieChartSectionData(
                      value: 100,
                      title: "No Data",
                      color: Colors.grey[300],
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: PieChart(
                        PieChartData(
                          sections: sections,
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 10,
                          centerSpaceRadius: 70,
                        ),
                      ),
                    ),

                    // Step 2: Pass categoryTotals & totalAmount to Category Row
                    _buildCategoryRow(categoryTotals, totalAmount),
                  ],
                );
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: ExpensesTable(userId: currentUser?.uid ?? ""),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddEntry(userId: currentUser?.uid ?? ""),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
