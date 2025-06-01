import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import '../../main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'group_list_page.dart';
import 'package:path/path.dart' as Path;

class CreateMailboxPage extends StatefulWidget {
  @override
  _CreateMailboxPageState createState() => _CreateMailboxPageState();
}

class _CreateMailboxPageState extends State<CreateMailboxPage> {
  String mailboxName = '';
  String invitationCode = '';
  bool isImageLoaded = false;
  PickedFile? _image;

  Future getImage() async {
    var image  = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image!;
    });

    if (_image != null) {
      setState(() {
        isImageLoaded = true;
      });
    }
  }

  void generateInvitationCode() {
    setState(() {
      invitationCode = randomAlphaNumeric(4); // 4글자의 숫자와 문자가 혼합된 초대 코드 생성
    });
  }

  void _createGroup(String groupLeader, File img) async{
    String fileName = Path.basename(img.path);
    TaskSnapshot task = await FirebaseStorage.instance
        .ref() // 시작점
        .child(invitationCode + '/' + fileName) // collection 이름
        .putFile(img);

    if(task != null)
    {
      var downloadUrl = await task.ref.getDownloadURL();
      FirebaseFirestore.instance.collection('groups').doc(invitationCode).set({
        'group_leader': groupLeader,
        'group_name': mailboxName,
        'code' : invitationCode,
        'img' : downloadUrl,
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
          'Email': groupLeader,
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
  }

  @override
  Widget build(BuildContext context) {
    final _email = Provider.of<Email>(context, listen: false).getEmail();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Mailbox'),
        ),
        body: ListView(
          children: [
            Padding(
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

                  Text(
                    '대표 사진:',
                    style: TextStyle(fontSize: 18),
                  ),

                  SizedBox(height: 16),

                  Center(
                    child: Container(
                      width: 350,
                      height: 200,
                      child: DottedBorder(
                        color: Colors.black,
                        strokeWidth: 1,
                        borderType: BorderType.RRect,
                        radius: Radius.circular(12),
                        child: Center(
                          child: InkWell(
                            onTap:(){
                              getImage();
                            },
                            child: isImageLoaded?Image.file(
                              File(_image!.path),
                              width: 340,
                              height: 190,
                              fit: BoxFit.fill,

                            ):
                            Container(
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white54.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.camera_alt_outlined),
                                  Text("사진 업로드"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: (){
                      _createGroup(_email, File(_image!.path));
                    },
                    child: Text('그룹 생성'),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
