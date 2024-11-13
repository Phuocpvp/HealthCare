import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';

class UpdateBodyIndexScreen extends StatefulWidget {
  @override
  _UpdateBodyIndexScreenState createState() => _UpdateBodyIndexScreenState();
}

class _UpdateBodyIndexScreenState extends State<UpdateBodyIndexScreen> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  double? _bmi;
  String _bmiCategory = "";

  void _calculateBMI() {
    final height = double.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);

    if (height != null && weight != null && height > 0) {
      setState(() {
        _bmi = weight / pow(height / 100, 2);
        _bmiCategory = _getBMICategory(_bmi!);
      });
    } else {
      setState(() {
        _bmi = null;
        _bmiCategory = "";
      });
    }
  }

  String _getBMICategory(double bmi) {
    if (bmi < 16) {
      return "Gầy độ 3";
    } else if (bmi < 16.9) {
      return "Gầy độ 2";
    } else if (bmi < 18.5) {
      return "Gầy độ 1";
    } else if (bmi < 24.9) {
      return "Bình thường";
    } else if (bmi < 29.9) {
      return "Tiền béo phì";
    } else if (bmi < 34.9) {
      return "Béo phì 1";
    } else if (bmi < 39.9) {
      return "Béo phì 2";
    } else {
      return "Béo phì 3";
    }
  }

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
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(hintText: 'Enter height in cm'),
              onChanged: (value) => _calculateBMI(),
            ),
            SizedBox(height: 16),
            Text("Enter Weight (in kg)"),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(hintText: 'Enter weight in kg'),
              onChanged: (value) => _calculateBMI(),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Gọi API để cập nhật chỉ số cơ thể
                print("Updating body index data...");
              },
              child: Text("Update Body Index"),
            ),
            SizedBox(height: 32),
            if (_bmi != null)
              Column(
                children: [
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(0.1),
                        border: Border.all(color: Colors.blue, width: 3),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _bmi!.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "BMI",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Tình trạng: $_bmiCategory",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
