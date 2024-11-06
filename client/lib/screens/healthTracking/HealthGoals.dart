import 'package:flutter/material.dart';

class HealthGoals extends StatefulWidget {
  @override
  _HealthGoals createState() => _HealthGoals();
}

class _HealthGoals extends State<HealthGoals> {
  final TextEditingController dayController = TextEditingController();
  final TextEditingController sleepController = TextEditingController();
  final TextEditingController bodyIndexController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Health Tracking")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter Day (Format: YYYY-MM-DD)"),
            TextField(
              controller: dayController,
              decoration: InputDecoration(hintText: 'Enter day'),
            ),
            SizedBox(height: 16),
            Text("Enter Sleep Data (e.g., 6 hours)"),
            TextField(
              controller: sleepController,
              decoration: InputDecoration(hintText: 'Enter sleep data'),
            ),
            SizedBox(height: 16),
            Text("Enter Body Index Data"),
            TextField(
              controller: bodyIndexController,
              decoration: InputDecoration(hintText: 'Enter body index data'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Call API to create new health tracking
                print("Creating new health tracking...");
              },
              child: Text("Create Health Tracking"),
            ),
          ],
        ),
      ),
    );
  }
}
