import 'package:flutter/material.dart';
import 'package:weather_app/weather_app_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.dark(useMaterial3: true).copyWith(appBarTheme: AppBarTheme()),// we can costimize app style from here too
      theme: ThemeData.dark(useMaterial3: true),
      home: weatherAppPage(),
    );
  }
}
