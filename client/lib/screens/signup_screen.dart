import 'package:client/models/user.dart';
import 'package:client/services/login_API.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthOfDateController = TextEditingController();

  String? _gender; // Biến lưu giá trị giới tính
  DateTime? _birthDate; // Biến lưu ngày sinh

  // Hàm đăng ký người dùng
  Future<void> _register() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String gender = _gender ?? ''; // Lấy giá trị giới tính đã chọn
    String birthOfDate = _birthOfDateController.text;

    final ApiService _apiService = ApiService();

    // Khởi tạo đối tượng User
    User user = User(
      username: username,
      email: email,
      password: password,
      gender: gender, // Truyền giá trị giới tính
      birthOfDate: birthOfDate, // Truyền ngày sinh
    );

    // Gọi API đăng ký
    bool success = await _apiService.registerUser(user);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký thành công!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký thất bại!')),
      );
    }
  }

  // Hàm chọn ngày sinh
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null && selectedDate != DateTime.now()) {
      setState(() {
        _birthDate = selectedDate;
        _birthOfDateController.text =
            "${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/signUp_dark_hc.jfif",
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let’s get started!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Please enter your valid data in order to create an account.",
                  ),
                  const SizedBox(height: defaultPadding),
                  // Form đăng ký
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên người dùng
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: defaultPadding),
                        // Email
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: defaultPadding),
                        // Mật khẩu
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: defaultPadding),
                        // Chọn giới tính
                        DropdownButtonFormField<String>(
                          value: _gender,
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Nam', 'Nữ'].map((String gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(
                                gender,
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your gender';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: defaultPadding),
                        // Chọn ngày sinh
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _birthOfDateController,
                              decoration: InputDecoration(
                                labelText: 'Birth Date',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your birth date';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  // Checkbox đồng ý với điều khoản
                  Row(
                    children: [
                      Checkbox(
                        onChanged: (value) {},
                        value: false,
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "I agree with the",
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, '/');
                                  },
                                text: " Terms of service ",
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const TextSpan(
                                text: "& privacy policy.",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: defaultPadding * 2),
                  // Button tiếp tục
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _register();
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', ModalRoute.withName('/register'));
                      }
                    },
                    child: const Text("Continue"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Do you have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                        child: const Text("Log in"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
