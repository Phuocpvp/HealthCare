import 'package:flutter/material.dart';

class UpdateBodyIndexScreen extends StatefulWidget {
  @override
  _UpdateBodyIndexScreenState createState() => _UpdateBodyIndexScreenState();
}

class _UpdateBodyIndexScreenState extends State<UpdateBodyIndexScreen> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Body Index")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter Height (in cm)"),
            TextField(
              controller: heightController,
              decoration: InputDecoration(hintText: 'Enter height'),
            ),
            SizedBox(height: 16),
            Text("Enter Weight (in kg)"),
            TextField(
              controller: weightController,
              decoration: InputDecoration(hintText: 'Enter weight'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Call API to update body index data
                print("Updating body index data...");
              },
              child: Text("Update Body Index"),
            ),
          ],
        ),
      ),
    );
  }
}
