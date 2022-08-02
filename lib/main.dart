import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:manek_tech_practicle/pages/HomePage.dart';
import 'package:manek_tech_practicle/utils/Strings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title:Strings.APP_TITLE,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Ubuntu-Regular",
        primarySwatch: Colors.indigo,
      ),
      home: const HomePage(title: Strings.APP_TITLE),
    );
  }
}
