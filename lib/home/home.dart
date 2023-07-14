import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../login/login.dart';
import '../main.dart';
import 'create_mailbox_page.dart';

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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        '편지함을 만들고 싶나요?',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // 만들기 버튼이 눌렸을 때 수행할 작업
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateMailboxPage(),
                            ),
                          );
                        },
                        child: Text('만들기'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        '편지함 주소를 알고 있나요?',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // 참여하기 버튼이 눌렸을 때 수행할 작업
                        },
                        child: Text('참여하기'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
