import 'package:client/screens/TestData.dart';
import 'package:client/screens/login_screen.dart';
import 'package:client/services/flutter_secure_storage.dart';
import 'package:client/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'routes/Routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final SecureStorageService _secureStorageService = SecureStorageService();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // Kiểm tra token khi ứng dụng khởi động
  String? token = await _secureStorageService.getValidAccessToken();
  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navigation Demo',
      theme: AppTheme.lightTheme(context),
      // Dark theme is inclided in the Full template
      themeMode: ThemeMode.light,
      initialRoute: isLoggedIn ? AppRoutes.testdata : AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
