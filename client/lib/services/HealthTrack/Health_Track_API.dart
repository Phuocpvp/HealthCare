import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Health_Track_API {
  final String baseUrl = '${dotenv.env['LOCALHOST']}';

  Future<void> updateBodyIndex(
      String userId, Map<String, dynamic> bodyIndexData) async {
    final url = Uri.parse('$baseUrl/update-bodyindex/$userId');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyIndexData),
      );

      if (response.statusCode == 200) {
        print("Cập nhật Body Index thành công");
      } else {
        print("Cập nhật thất bại: ${response.statusCode}");
        print(response.body);
      }
    } catch (error) {
      print("Có lỗi xảy ra: $error");
    }
  }
}
