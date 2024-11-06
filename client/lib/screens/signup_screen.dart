// import 'package:client/models/Login-DTO.dart';
import 'package:client/screens/components/sign_up_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:client/services/login_API.dart';
// import 'package:shop/route/route_constants.dart';

import '../../../constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  // // final TextEditingController _confirmPasswordController =
  // //     TextEditingController();

  // Future<void> _register() async {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();

  //     // Lấy thông tin từ controllers
  //     String username = _usernameController.text;
  //     String email = _emailController.text;
  //     String password = _passwordController.text;
  //   final ApiService _apiService = ApiService();

  //   // Kiểm tra các giá trị nhập vào
  //   // if (password != confirmPassword) {
  //   //   ScaffoldMessenger.of(context).showSnackBar(
  //   //     const SnackBar(
  //   //         content: Text('Password và Confirm Password không trùng khớp')),
  //   //   );
  //   //   return;
  //   // }

  //   // Tiến hành xử lý đăng ký (ví dụ: gửi dữ liệu lên server)
  //   // Tạo đối tượng User từ dữ liệu nhập
  //   User user = User(username: username /*, email: email*/, password: password);

  //   // Gọi API để đăng ký
  //   bool success = await _apiService.registerUser(user);

  //   // Hiển thị kết quả
  //   if (success) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Đăng ký thành công!')),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Đăng ký thất bại!')),
  //     );
  //   }

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
                  SignUpForm(formKey: _formKey),
                  const SizedBox(height: defaultPadding),
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
                      )
                    ],
                  ),
                  const SizedBox(height: defaultPadding * 2),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', ModalRoute.withName('/register'));
                      }
                      // _register();
                      // Navigator.pushNamed(context, '/');
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
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
