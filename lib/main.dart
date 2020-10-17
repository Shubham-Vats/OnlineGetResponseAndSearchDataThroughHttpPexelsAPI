import 'package:flutter/material.dart';
import 'Screens.dart';


void main()
{
  runApp((MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OnlineDataReadthroughHTTPpexels',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: FirstScreen(),
    );
  }
}