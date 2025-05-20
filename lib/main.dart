import 'package:flutter/material.dart';
import 'package:notific/noti_service.dart';

import 'home_page.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  NotiService().initNotification();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
