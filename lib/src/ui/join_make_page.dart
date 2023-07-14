import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobalworld/login/add_google_info.dart';
import 'package:mobalworld/login/login.dart';
import 'package:mobalworld/src/ui/main_loading.dart';

class JoinMakePage extends StatefulWidget {
  const JoinMakePage({Key? key}) : super(key: key);

  @override
  State<JoinMakePage> createState() => _JoinMakePageState();
}

class _JoinMakePageState extends State<JoinMakePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 160,
              ),
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
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF8E8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '편지함을 만들고 싶나요?',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'KOTRA HOPE'),
                            ),
                            SizedBox(
                              height: 90,
                            )
                          ],
                        ),
                        Container(
                          child: Transform.translate(
                            offset: Offset(0, 40),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GoogleAdditionalPage()));
                              },
                              child: Text(
                                '만들기',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'KOTRA HOPE'),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Color(0xFFFCCAA9),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF8E8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '편지함을 주소를 알고 있나요?',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'KOTRA HOPE'),
                            ),
                            SizedBox(
                              height: 90,
                            )
                          ],
                        ),
                        Container(

                          child: Transform.translate(
                            offset: Offset(0, 40),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                              child: Text(
                                '참여하기',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'KOTRA HOPE'),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Color(0xFFFCCAA9),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
