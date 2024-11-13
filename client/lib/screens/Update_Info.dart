import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Thêm package image_picker
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class UpdateInfo extends StatefulWidget {
  @override
  _UpdateProfile createState() => _UpdateProfile();
}

class _UpdateProfile extends State<UpdateInfo> {
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _email;
  String? _birthOfDate;
  String? _gender;
  String? _avatar;
  String? _token;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo(); // Gọi phương thức này để lấy thông tin người dùng
  }

  Future<void> _fetchUserInfo() async {
    // Giả sử bạn đã lấy được token trước đó
    _token = await _getToken();

    // Lấy thông tin người dùng từ server
    if (_token != null) {
      final response = await http.get(
        Uri.parse('${dotenv.env['LOCALHOST']}/user/profile'),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final userInfo = json.decode(response.body);
        setState(() {
          _username = userInfo['username'];
          _email = userInfo['email'];
          _birthOfDate = userInfo['birthOfDate'];
          _gender = userInfo['gender'];
          _avatar = userInfo['avatar'];
          _isLoading = false;
        });
      } else {
        print("Failed to load user info");
      }
    }
  }

  // Giả sử đây là phương thức lấy token đã lưu trong secure storage
  Future<String?> _getToken() async {
    // Đây là giả định, bạn cần thực hiện lấy token từ secure storage hoặc nơi lưu trữ.
    return "your_access_token_here";
  }

  // Phương thức để chọn hình ảnh từ thư viện hoặc camera
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource
            .gallery); // Hoặc ImageSource.camera để chụp ảnh từ camera
    if (image != null) {
      setState(() {
        _avatar = image.path; // Lưu đường dẫn file ảnh
      });
    }
  }

  // Cập nhật thông tin người dùng và hình ảnh
  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_token == null) {
        print("Token is missing");
        return;
      }

      try {
        var request = http.MultipartRequest(
          'PUT',
          Uri.parse('${dotenv.env['LOCALHOST']}/user/update'),
        );

        request.headers['Authorization'] = 'Bearer $_token';

        // Thêm dữ liệu vào request
        request.fields['username'] = _username ?? '';
        request.fields['email'] = _email ?? '';
        request.fields['birthOfDate'] = _birthOfDate ?? '';
        request.fields['gender'] = _gender ?? '';

        // Nếu có ảnh, thêm ảnh vào multipart request
        if (_avatar != null) {
          request.files
              .add(await http.MultipartFile.fromPath('avatar', _avatar!));
        }

        // Gửi request
        var response = await request.send();

        if (response.statusCode == 200) {
          Navigator.pushNamed(
              context, '/profile'); // Chuyển hướng đến trang hồ sơ
        } else {
          print("Failed to update user: ${response.reasonPhrase}");
        }
      } catch (error) {
        print("Failed to update user: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cập Nhật Thông Tin Người Dùng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                initialValue: _username,
                onSaved: (value) => _username = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                initialValue: _email,
                onSaved: (value) => _email = value,
              ),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Ngày sinh (yyyy-mm-dd)',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _birthOfDate =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    });
                  }
                },
                controller: TextEditingController(text: _birthOfDate),
                onSaved: (value) => _birthOfDate = value,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Giới tính'),
                value: _gender,
                items: [
                  DropdownMenuItem(child: Text('Nam'), value: 'male'),
                  DropdownMenuItem(child: Text('Nữ'), value: 'female'),
                  DropdownMenuItem(child: Text('Khác'), value: 'other'),
                ],
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
                onSaved: (value) => _gender = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Link ảnh đại diện'),
                initialValue: _avatar,
                onSaved: (value) => _avatar = value,
              ),
              // Thêm nút để chọn hình ảnh
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Chọn ảnh đại diện'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUser,
                child: Text('Cập Nhật'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
