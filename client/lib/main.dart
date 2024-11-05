import 'package:flutter/material.dart';
import 'routes/Routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navigation Demo',
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
