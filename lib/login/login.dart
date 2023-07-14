import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobalworld/login/add_google_info.dart';
import 'package:mobalworld/login/signup.dart';
import 'package:provider/provider.dart';

import '../home/home.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth anonAuth = FirebaseAuth.instance;
  late Email emailing;
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

  Future<void> _checkUser(String email) async{
    final usersRef = await FirebaseFirestore.instance.collection('user');
    QuerySnapshot querySnapshot =
        await usersRef.where('Email', isEqualTo: email).limit(1).get();

    // 쿼리 결과 확인
    if (querySnapshot.docs.length > 0) {
      // 동일한 이메일을 가진 문서가 존재하는 경우
      for (DocumentSnapshot doc in querySnapshot.docs) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage()
          ),
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
                          builder: (context) =>
                              GoogleAdditionalPage()
                      ),
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

  Future<String?> getEmail(String id, String password) async {
    // Firestore 인스턴스 생성
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // user 컬렉션에서 아이디와 일치하는 도큐먼트 쿼리
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('user')
        .where('Userid', isEqualTo: id)
        .get();

    // 일치하는 도큐먼트가 없는 경우 null 반환
    if (snapshot.docs.isEmpty) {
      return null;
    }

    // 비밀번호 비교
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = snapshot.docs.first;
    String storedPassword = docSnapshot.get('Password');

    // 비밀번호가 일치하는 경우 이메일 반환
    if (password == storedPassword) {
      String email = docSnapshot.get('Email');
      return email;
    }

    return null;
  }

  Future<bool> _handleSubmitted(
      String uid, String password) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('Userid', isEqualTo: uid)
        .where('Password', isEqualTo: password)
        .limit(1)
        .get();

    return querySnapshot.size == 1;
  }

  @override
  Widget build(BuildContext context) {
    emailing = Provider.of<Email>(context);
    final _usernameController = TextEditingController();
    final _passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 300,
                ),

                Container(
                  height: 54,
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      fillColor: Color(0xFFF4EBE4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,// Set the desired circular radius here
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6.0),
                Container(
                  height: 54,
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      fillColor: Color(0xFFF4EBE4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,// Set the desired circular radius here
                      ),
                    ),
                    obscureText: true,
                  ),
                ),

                SizedBox(height: 18),
                ElevatedButton(
                  child: const Text(
                    '로그인',
                    style: TextStyle(
                      color: Color(0xFF60544B),
                      fontFamily: 'gangwon',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary:  Color(0xFFE6DACE),
                    minimumSize: const Size(360, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Set the desired border radius here
                    ),

                  ),
                  onPressed: () async {
                    final uid = _usernameController.text;
                    final password = _passwordController.text;
                    final isMatched = await _handleSubmitted(uid, password);
                    if (isMatched) {
                      String? email = await getEmail(uid, password);
                      emailing.add(email!);
                      Navigator.push( context, MaterialPageRoute(
                          builder: (context){
                            return HomePage();
                          }
                      ));
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            backgroundColor: Color(0xFfF8ECE2),
                            title: Text('알림',
                              style: TextStyle(
                                  fontFamily: 'gangwon',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                  //color: Color(0xFF746553),
                                  color: Color(0xFF3C3731)

                              ),),
                            content: Text('아이디 혹은 비밀번호가 잘못 입력된 것 같아요. 다시 입력해 주세요!',
                              style: TextStyle(
                                  fontFamily: 'gangwon',
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6B5F51),
                                  fontSize: 21

                              ),),
                            actions: [
                              TextButton(
                                child: Text('OK',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF746553),
                                      fontSize: 18

                                  ),),
                                onPressed: () {
                                  setState(() {
                                    _passwordController.clear();
                                    _usernameController.clear();
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

                SizedBox(height: 20,),

                Center(
                  child: ElevatedButton(
                    child: Text('Google 계정으로 로그인'),
                    onPressed: () async {
                      final FirebaseAuth googleAuth = FirebaseAuth.instance;
                      final User? user = await _signInWithGoogle(googleAuth);
                      if (user != null) {
                        emailing.add(user.email.toString());
                        _checkUser(user.email.toString());
                      }
                      else {
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

                SizedBox(
                  height: 10,
                ),

                Center(
                  child: ElevatedButton(
                    child: Text('회원가입'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SignUpPage()
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
