import 'package:flutter/material.dart';

class UpdateSleepDataScreen extends StatefulWidget {
  @override
  _UpdateSleepDataScreenState createState() => _UpdateSleepDataScreenState();
}

class _UpdateSleepDataScreenState extends State<UpdateSleepDataScreen> {
  final TextEditingController sleepTimeController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Sleep Data")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter Sleep Duration (hours)"),
            TextField(
              controller: sleepTimeController,
              decoration: InputDecoration(hintText: 'Enter sleep duration'),
            ),
            SizedBox(height: 16),
            Text("Enter Sleep Start Time (e.g., 10:00 PM)"),
            TextField(
              controller: startTimeController,
              decoration: InputDecoration(hintText: 'Enter start time'),
            ),
            SizedBox(height: 16),
            Text("Enter Sleep End Time (e.g., 6:00 AM)"),
            TextField(
              controller: endTimeController,
              decoration: InputDecoration(hintText: 'Enter end time'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Call API to update sleep data
                print("Updating sleep data...");
              },
              child: Text("Update Sleep Data"),
            ),
          ],
        ),
      ),
    );
  }
}
