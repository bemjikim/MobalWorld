import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobalworld/login/add_google_info.dart';
import 'package:mobalworld/src/ui/main_loading.dart';
import 'package:provider/provider.dart';

import '../home/home.dart';
import '../main.dart';
import '../src/ui/join_make_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<String> dropdownOptions = ['home', 'login', 'loading'];
  late String selectedOption;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth anonAuth = FirebaseAuth.instance;
  late Email emailing;

  get routeNames => null;

  Future signInAnon(FirebaseAuth auth) async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      var user = await auth.currentUser;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> _signInWithGoogle(FirebaseAuth auth) async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      return user;
    }
    return null;
  }

  Future<void> _checkUser(String email) async {
    final usersRef = await FirebaseFirestore.instance.collection('user');
    QuerySnapshot querySnapshot =
        await usersRef.where('Email', isEqualTo: email).limit(1).get();

    // 쿼리 결과 확인
    if (querySnapshot.docs.length > 0) {
      // 동일한 이메일을 가진 문서가 존재하는 경우
      for (DocumentSnapshot doc in querySnapshot.docs) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } else {
      // 일치하는 문서가 없는 경우
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            title: Text(
              '알림',
            ),
            content: Text(
              '로그인을 위해 추가 정보를 입력해 주세요.',
            ),
            actions: [
              TextButton(
                child: Text(
                  '예',
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GoogleAdditionalPage()),
                    );
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    emailing = Provider.of<Email>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 300,
            ),
            Center(
              child: ElevatedButton(
                child: Text('Google 계정으로 로그인'),
                onPressed: () async {
                  final FirebaseAuth googleAuth = FirebaseAuth.instance;
                  final User? user = await _signInWithGoogle(googleAuth);
                  if (user != null) {
                    emailing.add(user.email.toString());
                    _checkUser(user.email.toString());
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          title: Text(
                            '알림',
                          ),
                          content: Text(
                            '로그인 실패!',
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                '예',
                              ),
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(context);
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
            DropdownButton<String>(
              hint: Text('페이지 이동'),
              items: [
                DropdownMenuItem(
                  value: 'joinmake',
                  child: Text('JoinMake'),
                ),
                DropdownMenuItem(
                  value: 'loading',
                  child: Text(
                    'loading',
                  ),
                ),
                DropdownMenuItem(
                  value: 'info',
                  child: Text(
                    'add_info',
                  ),
                )
              ],
              onChanged: (String? value) {
                if (value == 'joinmake') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => JoinMakePage()));
                } else if (value == 'loading') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoadingPage()));
                }  else if (value == 'info') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GoogleAdditionalPage()));
                }
              },
            ),

          ],
        ),
      ),
    );
  }
}
