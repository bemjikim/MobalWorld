import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../login/login.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final _email = Provider.of<Email>(context, listen: false).getEmail();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_email)
        ),
        body: Column(
          children: [
          ],
        )
      ),
    );
  }
}
