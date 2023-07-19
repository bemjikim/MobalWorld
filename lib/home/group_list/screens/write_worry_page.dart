import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';


class WriteWorryPage extends StatefulWidget {
  final String groupId; // 그룹코드
  final String groupName; // 유저 이메일

  const WriteWorryPage({required this.groupId, required this.groupName});

  @override
  State<WriteWorryPage> createState() => _WriteWorryPageState();
}

class _WriteWorryPageState extends State<WriteWorryPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController worryController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    worryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _email = Provider.of<Email>(context, listen: false).getEmail();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: worryController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Worry',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String title = titleController.text;
                String worry = worryController.text;

                await Firebase.initializeApp();
                FirebaseFirestore firestore = FirebaseFirestore.instance;

                // 1. send_letter 컬렉션 참조 가져오기
                CollectionReference sendLetterCollection = firestore
                    .collection('groups')
                    .doc(widget.groupId)
                    .collection('group_users')
                    .doc(_email)
                    .collection('send_letter');

                // 2. 편지 정보를 맵으로 만들기
                Map<String, dynamic> letterData = {
                  'title': title,
                  'worry': worry,
                  // 다른 필요한 정보들도 추가 가능
                };

                // 3. 편지를 send_letter 컬렉션에 추가하기 (자동 생성 ID 사용)
                DocumentReference newLetterRef = await sendLetterCollection.add(letterData);
                // 4. 자동 생성된 ID 가져오기
                String documentId = _email;
                // 5. 자동 생성된 ID를 해당 문서의 필드에 추가하기
                Map<String, dynamic> letterDataWithId = {
                  ...letterData,
                  'id': documentId,
                };
                // 6. 해당 문서 업데이트 (ID를 포함한 데이터로 업데이트)
                await newLetterRef.set(letterDataWithId);
              },
              child: Text('Complete'),
            ),
          ],
        ),
      ),
    );
  }
}