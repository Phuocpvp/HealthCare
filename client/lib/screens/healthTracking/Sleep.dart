import 'package:flutter/material.dart';

class UpdateSleepDataScreen extends StatefulWidget {
  @override
  _UpdateSleepDataScreenState createState() => _UpdateSleepDataScreenState();
}

class _UpdateSleepDataScreenState extends State<UpdateSleepDataScreen> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  Duration? _sleepDuration;
  String _sleepComment = "";

  void _pickStartTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _startTime = pickedTime;
        _calculateSleepDuration();
      });
    }
  }

  void _pickEndTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _endTime = pickedTime;
        _calculateSleepDuration();
      });
    }
  }

  void _calculateSleepDuration() {
    if (_startTime != null && _endTime != null) {
      final start = DateTime(0, 1, 1, _startTime!.hour, _startTime!.minute);
      final end = DateTime(0, 1, 1, _endTime!.hour, _endTime!.minute);

      // If the end time is earlier than the start time, assume the sleep duration spans midnight.
      final duration = end.isAfter(start)
          ? end.difference(start)
          : end.add(Duration(days: 1)).difference(start);

      setState(() {
        _sleepDuration = duration;
        _sleepComment = _getSleepComment(duration);
      });
    }
  }

  String _getSleepComment(Duration duration) {
    final hours = duration.inHours;
    if (hours < 6) {
      return "Thiếu ngủ";
    } else if (hours <= 8) {
      return "Ngủ đủ";
    } else {
      return "Ngủ quá nhiều";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Sleep Data")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Chọn thời gian bắt đầu giấc ngủ"),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _pickStartTime,
              child: Text(
                _startTime != null
                    ? "Bắt đầu: ${_startTime!.format(context)}"
                    : "Chọn thời gian bắt đầu",
              ),
            ),
            SizedBox(height: 16),
            Text("Chọn thời gian kết thúc giấc ngủ"),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _pickEndTime,
              child: Text(
                _endTime != null
                    ? "Kết thúc: ${_endTime!.format(context)}"
                    : "Chọn thời gian kết thúc",
              ),
            ),
            SizedBox(height: 32),
            if (_sleepDuration != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tổng thời gian ngủ: ${_sleepDuration!.inHours} giờ ${_sleepDuration!.inMinutes % 60} phút",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Nhận xét: $_sleepComment",
                    style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                  ),
                ],
              ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Call API to update sleep data
                print("Updating sleep data...");
              },
              child: Text("Cập nhật dữ liệu giấc ngủ"),
            ),
          ],
        ),
      ),
    );
  }
}
