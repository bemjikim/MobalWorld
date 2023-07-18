import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnswerPage extends StatefulWidget {
  final String groupId;
  final String title;
  final String worry;
  final String letter_id;

  const AnswerPage({required this.groupId,required this.title, required this.worry, required this.letter_id});

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  TextEditingController answerController = TextEditingController();

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: ListTile(
                  title: Text(widget.title),
                  subtitle: Text(widget.worry),
                ),
              ),
              TextField(
                controller: answerController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  String answer = answerController.text;

                  await Firebase.initializeApp();
                  FirebaseFirestore firestore = FirebaseFirestore.instance;

                  // // 1. send_letter 컬렉션 참조 가져오기
                  CollectionReference receiveLetterCollection = firestore
                      .collection('groups')
                      .doc(widget.groupId)
                      .collection('group_users')
                      .doc(widget.letter_id)
                      .collection('receive_letter');

                  // 2. 편지 정보를 맵으로 만들기
                  Map<String, dynamic> letterData = {
                    'answer': answer,
                    // 다른 필요한 정보들도 추가 가능
                  };
                  // 3. 편지를 receive_letter 컬렉션에 추가하기
                  await receiveLetterCollection.add(letterData);
                },
                child: Text('Complete'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
