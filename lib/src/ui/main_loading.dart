import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobalworld/login/login.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: Icon(
              Icons.water_drop_outlined,
              size: 60,
            )),
            Container(
              alignment: Alignment.bottomCenter,
              child: const Text(
                '마음의 편지',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'KOTRA HOPE',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
