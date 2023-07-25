import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../otp/otp.dart';
import 'group_main_page.dart';

class GroupAttendPage extends StatefulWidget {
  const GroupAttendPage({Key? key}) : super(key: key);

  @override
  State<GroupAttendPage> createState() => _GroupAttendPageState();
}

class _GroupAttendPageState extends State<GroupAttendPage> {
  // 4 text editing controllers that associate with the 4 input fields
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();

  // This is the entered code
  // It will be displayed in a Text widget
  String? _otp;
  bool matched = false;

  Future<void> _checkCode(
      String code, String email) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .where('code', isEqualTo: code)
        .limit(1)
        .get();

    if(querySnapshot.size == 1)
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
                  fontSize: 24,
                  //color: Color(0xFF746553),
                  color: Color(0xFF3C3731)

              ),),
            content: Text("그룹가입 성공!",
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
                onPressed: () async {
                  FirebaseFirestore.instance
                      .collection('groups')
                      .doc(code)
                      .collection('group_users')
                      .doc(email)
                      .set({
                    'Email': email,
                    // 추가적인 필드들을 필요에 따라 여기에 추가하세요
                  });
                  setState(() {
                    matched = false;
                  });
                  DocumentSnapshot<Map<String, dynamic>> snapshot =
                      await FirebaseFirestore.instance.collection('groups').doc(code).get();
                  String groupName = snapshot.data()?['group_name'];

                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupMainPage(
                        groupId: code,
                        groupName: groupName,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    else
      setState(() {
        matched = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    final _email = Provider.of<Email>(context, listen: false).getEmail();
    return Scaffold(
      appBar: AppBar(
        title: const Text('그룹 코드 입력'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          matched?Text(
            '잘못된 그룹코드입니다!',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ):
          Text('그룹코드를 입력해주세요'),
          const SizedBox(
            height: 30,
          ),
          // Implement 4 input fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OtpInput(_fieldOne, true), // auto focus
              OtpInput(_fieldTwo, false),
              OtpInput(_fieldThree, false),
              OtpInput(_fieldFour, false)
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _otp = _fieldOne.text +
                      _fieldTwo.text +
                      _fieldThree.text +
                      _fieldFour.text;
                  //디버그용!! 삭제하셔도 됩니다.
                });
                _checkCode(_otp!, _email);
              },
              child: const Text('Submit')),
          const SizedBox(
            height: 30,
          ),
          // Display the entered OTP code
        ],
      ),
    );
  }
}