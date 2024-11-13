import 'package:client/services/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/services/api_service.dart';

class Disease extends StatefulWidget {
  @override
  _DiseaseState createState() => _DiseaseState();
}

class _DiseaseState extends State<Disease> {
  List<dynamic> diseases = [];
  List<bool> isExpandedList = [];
  final tokenService = SecureStorageService();
  String userId = '';
  String diseaseId = '';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchDiseases();
  }

  Future<void> fetchDiseases() async {
    String? token = await tokenService.getValidAccessToken();
    if (token == null) {
      print('No token found or failed to refresh token.');
      return;
    }

    final response = await http.get(
      Uri.parse('${dotenv.env['LOCALHOST']}/disease'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        diseases = json.decode(response.body);
        isExpandedList = List.generate(diseases.length, (index) => false);
      });
    } else {
      print('Failed to load diseases with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> fetchUserInfo() async {
    String? token = await tokenService.getValidAccessToken();
    if (token == null) {
      print('No token found or failed to refresh token.');
      return;
    }

    final response = await http.get(
      Uri.parse('${dotenv.env['LOCALHOST']}/user/id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        final userIdInfo = json.decode(response.body);
        setState(() {
          userId = userIdInfo['userId'];
        });
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      print('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bệnh của bạn là ? '),
      ),
      body: ListView.builder(
        itemCount: diseases.length,
        itemBuilder: (context, index) {
          diseaseId = diseases[index]['_id'];

          List<Color> boxColors = [
            Colors.blueAccent,
            Colors.greenAccent,
            Colors.orangeAccent,
            Colors.purpleAccent,
            Colors.redAccent,
          ];

          Color boxColor = boxColors[index % boxColors.length];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpandedList[index] = !isExpandedList[index];
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(16.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 4,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      diseases[index]['Disease'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    if (isExpandedList[index])
                      ..._buildQuestionList(diseases[index]['ListQuestion'])
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildQuestionList(Map<String, dynamic>? listQuestions) {
    if (listQuestions == null || listQuestions.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Không có câu hỏi nào.",
            style: TextStyle(color: Colors.black),
          ),
        )
      ];
    }
    return listQuestions.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                entry.value,
                style: TextStyle(color: Colors.black),
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _showAnswerDialog(entry.key, entry.value);
              },
            ),
          ],
        ),
      );
    }).toList();
  }

  void _showAnswerDialog(String questionId, String questionText) async {
    final TextEditingController answerController = TextEditingController();
    bool isExistingAnswer = false;

    try {
      String previousAnswer = await ApiService('${dotenv.env['LOCALHOST']}')
          .getExistingAnswer(userId, diseaseId, questionId);

      if (previousAnswer.isNotEmpty) {
        answerController.text = previousAnswer;
        isExistingAnswer = true;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Nhập câu trả lời cho: $questionText'),
            content: TextField(
              controller: answerController,
              decoration: InputDecoration(hintText: 'Nhập câu trả lời của bạn'),
            ),
            actions: [
              TextButton(
                child: Text('Hủy'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Xác nhận'),
                onPressed: () async {
                  String answer = answerController.text;

                  if (answer.isNotEmpty) {
                    try {
                      if (isExistingAnswer) {
                        await ApiService('${dotenv.env['LOCALHOST']}')
                            .updateAnswer(
                                userId, diseaseId, questionId, answer);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Câu trả lời đã được cập nhật!')),
                        );
                      } else {
                        await ApiService('${dotenv.env['LOCALHOST']}')
                            .createAnswer(
                                questionId, answer, userId, diseaseId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Câu trả lời đã được lưu!')),
                        );
                      }
                      Navigator.of(context).pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Lỗi khi xử lý câu trả lời: $e')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Vui lòng nhập câu trả lời.')),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi kiểm tra câu trả lời: $e')),
      );
    }
  }
}
