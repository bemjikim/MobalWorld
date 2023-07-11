import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  @override
  Widget build(BuildContext context) {
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
                    await FirebaseFirestore.instance
                        .collection('user')
                        .doc(user.uid)
                        .set({
                      'email': user.email,
                      'name': user.displayName,
                      'status_message':
                      '“I promise to take the test honestly before GOD.',
                      'uid': user.uid,
                    });
                    var currentUserProvider = Provider.of<CurrentUserModel>(context, listen: false);
                    currentUserProvider.adduser(user);
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
                            '로그인 성공!!',
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
                                            HomePage()
                                    ),
                                  );
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );

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
          ],
        ),
      ),
    );
  }
}
