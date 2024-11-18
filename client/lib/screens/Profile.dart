import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:client/services/flutter_secure_storage.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserProfile createState() => _UserProfile();
}

class _UserProfile extends State<UserInfo> {
  final SecureStorageService _secureStorageService = SecureStorageService();
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic>? userData;
  bool _isLoading = true;
  Uint8List? _imageBytes; // Dùng để hiển thị ảnh đã chọn trên web và mobile
  String? _avatarUrl; // Link ảnh trên server

  // Controllers cho các trường thông tin người dùng
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _genderController;
  late TextEditingController _birthOfDateController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _genderController = TextEditingController();
    _birthOfDateController = TextEditingController();
    _fetchUserInfo();
  }

  // Lấy thông tin người dùng từ server
  Future<void> _fetchUserInfo() async {
    String? token = await _secureStorageService.getValidAccessToken();
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('${dotenv.env['LOCALHOST']}/user/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        userData = json.decode(response.body);
        _isLoading = false;

        // Khởi tạo controllers với dữ liệu người dùng
        _usernameController.text = userData!['username'];
        _emailController.text = userData!['email'];
        _genderController.text = userData!['gender'];
        _birthOfDateController.text =
            userData!['birthOfDate'] ?? 'Not provided';

        // Khởi tạo link ảnh đại diện
        _avatarUrl = userData!['avatar'];
      });
    } else {
      throw Exception('Failed to load user info');
    }
  }

  // Chọn và tải ảnh lên server, sau đó cập nhật link ảnh
  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        // Đọc ảnh để hiển thị ngay sau khi chọn
        _imageBytes = await pickedFile.readAsBytes();
        setState(() {}); // Cập nhật UI để hiển thị ảnh

        String? token = await _secureStorageService.getValidAccessToken();
        if (token == null) throw Exception('No token found');

        var request = http.MultipartRequest(
          'PUT',
          Uri.parse('${dotenv.env['LOCALHOST']}/user/update/avatar'),
        );
        request.headers['Authorization'] = 'Bearer $token';

        if (kIsWeb) {
          // Xử lý ảnh cho nền tảng web
          request.files.add(http.MultipartFile.fromBytes(
            'avatar',
            _imageBytes!,
            filename: pickedFile.name,
          ));
        } else {
          // Xử lý ảnh cho nền tảng mobile
          request.files.add(await http.MultipartFile.fromPath(
            'avatar',
            pickedFile.path,
          ));
        }

        var response = await request.send();
        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          final responseBody = json.decode(responseData);

          setState(() {
            _avatarUrl =
                responseBody['avatarUrl']; // Cập nhật link ảnh trên server
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Cập nhật ảnh thành công!')));
        } else {
          throw Exception('Failed to upload avatar');
        }
      } catch (e) {
        print("Error uploading image: $e");
      }
    } else {
      print("No image selected.");
    }
  }

  // Cập nhật thông tin người dùng
  Future<void> _updateUserInfo() async {
    String? token = await _secureStorageService.getValidAccessToken();
    if (token == null) throw Exception('No token found');

    final response = await http.put(
      Uri.parse('${dotenv.env['LOCALHOST']}/user/update'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': _usernameController.text,
        'email': _emailController.text,
        'gender': _genderController.text,
        'birthOfDate': _birthOfDateController.text,
        'avatar': _avatarUrl, // Cập nhật link ảnh mới
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Thông tin đã được cập nhật!')));
    } else {
      throw Exception('Failed to update user info');
    }
  }

  // Hàm chọn ngày
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), // Ngày đầu tiên được chọn
      lastDate: DateTime.now(), // Ngày cuối cùng được chọn
    );
    if (selectedDate != null && selectedDate != DateTime.now()) {
      // Cập nhật giá trị ngày sinh theo định dạng yyyy-MM-dd
      _birthOfDateController.text =
          selectedDate.toLocal().toString().split(' ')[0];
    }
  }

  // Build giao diện
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('User Information', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : userData == null
              ? Center(child: Text('No user data available'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildUserAvatar(_avatarUrl),
                        SizedBox(height: 20),
                        _buildEditableField('Username', _usernameController),
                        _buildEditableField('Email', _emailController),
                        _buildGenderField(), // Giới tính chọn Nam/Nữ
                        _buildBirthOfDateField(),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                            ),
                            onPressed: _updateUserInfo,
                            child: Text('Lưu Thông Tin',
                                style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  // Widget để hiển thị và chọn ảnh đại diện
  Widget _buildUserAvatar(String? avatarUrl) {
    return GestureDetector(
      onTap: _pickAndUploadImage,
      child: Center(
        child: CircleAvatar(
          radius: 60,
          backgroundImage: _imageBytes != null
              ? MemoryImage(_imageBytes!)
              : (avatarUrl != null
                  ? NetworkImage(avatarUrl)
                  : AssetImage('assets/default_avatar.png') as ImageProvider),
          backgroundColor: Colors.grey[200],
        ),
      ),
    );
  }

  // Widget để hiển thị trường chỉnh sửa thông tin người dùng
  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label không được để trống';
          }
          return null;
        },
      ),
    );
  }

  // Widget cho ngày sinh với date picker
  Widget _buildBirthOfDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => _selectDate(context), // Mở date picker khi nhấn vào ô
        child: AbsorbPointer(
          child: TextFormField(
            controller: _birthOfDateController,
            decoration: InputDecoration(
              labelText: 'Birth of Date',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ngày sinh không được để trống';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  // Widget cho giới tính
  Widget _buildGenderField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _genderController.text.isEmpty ? null : _genderController.text,
        decoration: InputDecoration(
          labelText: 'Gender',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (String? newValue) {
          setState(() {
            _genderController.text = newValue!;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Giới tính không được để trống';
          }
          return null;
        },
        items:
            <String>['Nam', 'Nữ'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          );
        }).toList(),
      ),
    );
  }
}
