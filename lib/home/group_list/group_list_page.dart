import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupListPage extends StatelessWidget {
  final CollectionReference _groups =
      FirebaseFirestore.instance.collection('groups');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group List'),
      ),
      body: StreamBuilder(
        stream: _groups.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                final String groupId = documentSnapshot.id;
                final CollectionReference groupUsersRef = FirebaseFirestore.instance
                    .collection('groups')
                    .doc(groupId)
                    .collection('group_users');
                return Card(
                  color: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.amber,
                    ),
                    title: Text(
                      documentSnapshot['group_name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: StreamBuilder(
                      stream: groupUsersRef.snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
                        if (userSnapshot.hasData) {
                          final int userCount = userSnapshot.data!.docs.length;
                          return Text(
                            '참가자 $userCount명',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // IconButton(
                          //     onPressed: onPressed,
                          //     icon: Icon(Icons.delete),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      //floatingActionButton: Flo,
    );
  }
}
