import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import '../main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'group_list/group_list_page.dart';


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

  void _createGroup(String groupLeader) {
    FirebaseFirestore.instance.collection('groups').doc(invitationCode).set({
      'group_leader': groupLeader,
      'group_name': mailboxName,
      // 추가적인 필드들을 필요에 따라 여기에 추가하세요
    })
        .then((value) {
      // 데이터 저장이 성공한 경우의 처리를 여기에 작성하세요
      print('Group created successfully!');

      // group_users 컬렉션에 groupLeader 추가
      FirebaseFirestore.instance
          .collection('groups')
          .doc(invitationCode)
          .collection('group_users')
          .doc(groupLeader)
          .set({
        'user_id': groupLeader,
        // 추가적인 필드들을 필요에 따라 여기에 추가하세요
      })
          .then((value) {
        // group_users 컬렉션에 groupLeader 추가가 성공한 경우의 처리를 여기에 작성하세요
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupListPage(),
          ),
        );
        print('Group leader added successfully!');
      })
          .catchError((error) {
        // group_users 컬렉션에 groupLeader 추가가 실패한 경우의 처리를 여기에 작성하세요
        print('Failed to add group leader: $error');
      });
    })
        .catchError((error) {
      // 데이터 저장이 실패한 경우의 처리를 여기에 작성하세요
      print('Failed to create group: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final _email = Provider.of<Email>(context, listen: false).getEmail();
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
                _createGroup(_email);
              },
              child: Text('그룹 생성'),
            ),
          ],
        ),
      ),
    );
  }
}
