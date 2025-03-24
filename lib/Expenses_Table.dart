import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpensesTable extends StatelessWidget {
  final String userId;

  ExpensesTable({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("expenses")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var expenses = snapshot.data!.docs;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Action')),
            ],
            rows: expenses.map((doc) {
              return DataRow(cells: [
                DataCell(Text(doc["date"])),
                DataCell(Text(doc["category"])),
                DataCell(Text(doc["amount"])),
                DataCell(IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(userId)
                        .collection("expenses")
                        .doc(doc.id)
                        .delete();
                  },
                )),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}

class AddEntry extends StatefulWidget {
  final String userId;

  const AddEntry({super.key, required this.userId});

  @override
  State<AddEntry> createState() => _AddEntryState();
}

class _AddEntryState extends State<AddEntry> {
  TextEditingController categoryController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String selectedDate = "Pick a date";

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _addData() async {
    if (selectedDate == "Pick a date" ||
        categoryController.text.isEmpty ||
        amountController.text.isEmpty) {
      return;
    }
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .collection("expenses")
        .add({
      "date": selectedDate,
      "category": categoryController.text,
      "amount": amountController.text,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Enter Expense Data"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => _pickDate(context),
            child: Text(selectedDate),
          ),
          TextField(
            controller: categoryController,
            decoration: InputDecoration(labelText: "Category"),
          ),
          TextField(
            controller: amountController,
            decoration: InputDecoration(labelText: "Amount"),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel")),
        ElevatedButton(onPressed: _addData, child: Text("Submit")),
      ],
    );
  }
}
