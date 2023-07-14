import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'group_list/group_list_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CreateMailboxPage extends StatefulWidget {
  @override
  _CreateMailboxPageState createState() => _CreateMailboxPageState();
}

class _CreateMailboxPageState extends State<CreateMailboxPage> {
  String mailboxName = '';
  String invitationCode = '';

  void generateInvitationCode() {
    setState(() {
      invitationCode = randomAlphaNumeric(4); // 4글자의 숫자와 문자가 혼합된 초대 코드 생성
    });
  }

  void _createGroup() {
    FirebaseFirestore.instance.collection('groups').doc(invitationCode).set({
      'group_name': mailboxName,
      // 추가적인 필드들을 필요에 따라 여기에 추가하세요
    })
        .then((value) {
      // 데이터 저장이 성공한 경우의 처리를 여기에 작성하세요
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroupListPage(),
        ),
      );
      print('Group created successfully!');
    })
        .catchError((error) {
      // 데이터 저장이 실패한 경우의 처리를 여기에 작성하세요
      print('Failed to create group: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Mailbox'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '편지함 이름:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  mailboxName = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                generateInvitationCode();
                // 편지함 생성 및 초대 코드 저장 작업 수행
              },
              child: Text('초대 코드 만들기'),
            ),
            SizedBox(height: 16),
            Text(
              '초대 코드:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              invitationCode,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: (){
                _createGroup();
              },
              child: Text('그룹 생성'),
            ),
          ],
        ),
      ),
    );
  }
}
