import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'answer_page.dart';

class ComunityPage extends StatefulWidget {
  final String groupId; //그룹코드
  const ComunityPage({required this.groupId});

  @override
  State<ComunityPage> createState() => _ComunityPageState();
}

class _ComunityPageState extends State<ComunityPage> {
  @override
  Widget build(BuildContext context) {
    final CollectionReference _groupUsersRef = FirebaseFirestore
        .instance
        .collection('groups')
        .doc(widget.groupId)
        .collection('group_users');

    return Scaffold(
      body: StreamBuilder(
        stream: _groupUsersRef.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                streamSnapshot.data!.docs[index];
                final String userName = documentSnapshot.id;
                final CollectionReference _sendLetterRef = FirebaseFirestore
                    .instance
                    .collection('groups')
                    .doc(widget.groupId)
                    .collection('group_users')
                    .doc(userName)
                    .collection('send_letter');

                return FutureBuilder<QuerySnapshot>(
                  future: _sendLetterRef.get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        final letters = snapshot.data!.docs;
                        return Column(
                          children: letters.map((letter) {
                            final title = letter['title'];
                            final worry = letter['worry'];
                            final worry_user = letter['id'];
                            return GestureDetector(
                              onTap: () {
                                // Navigate to the "Answer Page" with necessary data
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AnswerPage(
                                      title: title,
                                      worry: worry,
                                      letter_id: worry_user,
                                      groupId: widget.groupId,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(title),
                                  subtitle: Text(worry),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return const Text('No letters found.');
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

