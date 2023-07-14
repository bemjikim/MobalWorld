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

  void signOut() async {
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final _email = Provider.of<Email>(context, listen: false).getEmail();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_email),
          leading: Expanded(
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new,
                    color: Color(0xFF72614E)),
                onPressed: () {
                  signOut();
                  Navigator.pop(context);
                },
              )
          ),
        ),
        body: Column(
          children: [
          ],
        )
      ),
    );
  }
}
