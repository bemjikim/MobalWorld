import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobalworld/home/home.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class GoogleAdditionalPage extends StatefulWidget {
  const GoogleAdditionalPage({Key? key}) : super(key: key);

  @override
  State<GoogleAdditionalPage> createState() => _GoogleAdditionalPageState();
}

Widget numberInsert(
    {
      bool? editAble,
      String? hintText,
      FocusNode? focusNode,
      TextEditingController? controller,
      required TextInputAction textInputAction,
      Function? widgetFunction,
      int? maxLegnth,

    }){
  return TextFormField(
    enabled: editAble,
    style: TextStyle(
      fontSize: 12,
    ),
    decoration: InputDecoration(
      contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      isDense: true,
      counterText: "",
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
    ),

    textInputAction: textInputAction,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly,],
    focusNode:focusNode,
    controller: controller,
    maxLength: maxLegnth,
    onChanged: (value){
    },
  );
}

class _GoogleAdditionalPageState extends State<GoogleAdditionalPage> {
  final _nicknameController = TextEditingController();
  final _verification = TextEditingController();
  final TextEditingController phoneNumberController1 = TextEditingController();
  final TextEditingController phoneNumberController2 = TextEditingController();
  FocusNode phoneNumberFocusNode1=FocusNode();
  FocusNode phoneNumberFocusNode2=FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';
  final _formKey = GlobalKey<FormState>();
  bool _isUserIdExists = false;
  bool _uidinvalid = false;
  bool sending = false;
  bool smscheck = false;

  Future<bool> _checkuserid(String nickname) async{
    setState(() {
      FocusScope.of(context).unfocus();
    });
    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('Nickname', isEqualTo: nickname)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<void> _registerUser(String email, String nickname, String phonenumber) async{
    final userRef = await FirebaseFirestore.instance.collection('user').doc(email);
    userRef.set({
      'Email' : email,
      'NickName': nickname,
      'PhoneNumber': phonenumber
    });
  }

  Future<void> _verifyPhoneNumber(String number) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      // 자동 인증이 완료된 경우
      await _auth.signInWithCredential(phoneAuthCredential);
      // 인증 완료 후 처리할 작업 수행
      // 예: 사용자 정보 저장, 화면 전환 등
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      // 인증 실패 시 처리할 작업 수행
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      // 인증 코드가 전송된 경우
      setState(() {
        _verificationId = verificationId;
        sending = true;
      });
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      // 인증 코드 자동 검색 시간 초과
    };

    await _auth.verifyPhoneNumber(
      phoneNumber: number, // 사용자 휴대폰 번호 입력
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<void> _signInWithPhoneNumber(String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      // 인증 완료 후 처리할 작업 수행
      // 예: 사용자 정보 저장, 화면 전환 등
      setState(() {
        smscheck = true;
      });
    } catch (e) {
      // 인증 실패 시 처리할 작업 수행
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
              '인증번호가 일치하지 않습니다! 다시 입력해주세요.',
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFEF5ED),
        elevation: 1,
        title:  Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 50.0, 0.0),
            child: const Text(
              '추가 정보 입력',
              style: TextStyle(
                  fontFamily: 'gangwon',
                  color: Color(0xFF72614E),
                  fontWeight: FontWeight.w600,
                  fontSize: 25),

            ),
          ),
        ),
        iconTheme: IconThemeData(
            color: Color(0xFF72614E),
            size: 26// 원하는 색상으로 변경하세요
        ),

      ),
      body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        '  별명*',
                        style: TextStyle(
                          fontFamily: 'gangwon',
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 20,)
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      children: [
                        Expanded(
                          child:Container(
                            height:45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color:Color(0xffEDE5DF),

                            ),
                            child: TextFormField(
                              onTapOutside: (event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              controller: _nicknameController,
                              autofocus: true,

                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                hintText: '별명을 입력해 주세요.',
                                labelStyle: TextStyle(
                                  color: Color(0xFFC0B8B1),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        ElevatedButton(
                          child: const Text(
                            '중복확인',
                            style: TextStyle(
                                fontFamily: 'gangwon',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFE6CCAD),
                            minimumSize: const Size(18, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // 버튼의 모서리를 둥글게 설정
                            ),
                          ),
                          onPressed: () async{
                            if(_nicknameController.text.length > 0)
                            {
                              _isUserIdExists = await _checkuserid(_nicknameController.text);
                              if (_isUserIdExists) {
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
                                      content: Text('이미 존재하는 별명입니다.',
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
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              else
                              {
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
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'gangwon',
                                            fontSize: 24,
                                            //color: Color(0xFF746553),
                                            color: Color(0xFF3C3731)

                                        ),),
                                      content: Text('사용가능한 별명입니다.',
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
                                          onPressed: () {
                                            setState(() {
                                              _uidinvalid = true;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 14.0),
                    Text(
                        '  휴대번호*',
                        style: TextStyle(
                          fontFamily: 'gangwon',
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 20,)
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: numberInsert(
                              editAble: false,
                              hintText: "010",
                              textInputAction: TextInputAction.next,
                            )),
                        SizedBox(width: 5,),
                        Expanded(
                          flex: 1,
                          child: numberInsert(
                            hintText: "",
                            focusNode: phoneNumberFocusNode1,
                            controller: phoneNumberController1,
                            editAble: !sending,
                            maxLegnth: 4,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          flex: 1,
                          child: numberInsert(
                            hintText: "",
                            focusNode: phoneNumberFocusNode2,
                            controller: phoneNumberController2,
                            editAble: !sending,
                            maxLegnth: 4,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        SizedBox(width: 20,),
                        sending?Container(
                          width: 120,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "요청완료",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'gangwon',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20
                              ),
                            ),
                          ),
                        ):
                        ElevatedButton(
                          child: const Text(
                            '인증요청',
                            style: TextStyle(
                                fontFamily: 'gangwon',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFE6CCAD),
                            minimumSize: const Size(18, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // 버튼의 모서리를 둥글게 설정
                            ),
                          ),
                          onPressed: (){
                            _verifyPhoneNumber('+82 10-'+phoneNumberController1.text+'-'+ phoneNumberController2.text);
                          }
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text(
                        '   *본인인증으로만 활용하고 그 이외에 이용되지 않습니다.',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 14,)
                    ),

                    SizedBox(height: 14,),

                    if(sending)
                    Row(
                      children: [
                        Expanded(
                          child:Container(
                            height:45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color:Color(0xffEDE5DF),

                            ),
                            child: TextFormField(
                              onTapOutside: (event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              controller: _verification,
                              autofocus: true,
                              enabled: !smscheck,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                hintText: '인증 코드를 입력해주세요',
                                labelStyle: TextStyle(
                                  color: Color(0xFFC0B8B1),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),

                        smscheck? Container(
                          width: 120,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                                "인증완료",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'gangwon',
                                fontWeight: FontWeight.w600,
                                fontSize: 20
                              ),
                            ),
                          ),
                        ):
                        ElevatedButton(
                          child: const Text(
                            '인증확인',
                            style: TextStyle(
                                fontFamily: 'gangwon',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFE6CCAD),
                            minimumSize: const Size(18, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // 버튼의 모서리를 둥글게 설정
                            ),
                          ),
                          onPressed: () async{
                            _signInWithPhoneNumber(_verification.text);
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 76.0),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            child: const Text(
                              '회원가입',
                              style: TextStyle(
                                  fontFamily: 'gangwon',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFE6CCAD),
                              minimumSize: const Size(360, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // 버튼의 모서리를 둥글게 설정
                              ),
                            ),
                            onPressed: () {
                              if(_uidinvalid && smscheck) {
                               // 여기에 회원가입 submit 버튼
                                _registerUser(Provider.of<Email>(context, listen: false).getEmail(), _nicknameController.text, phoneNumberController1.text+phoneNumberController2.text);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(),
                                  ),
                                );
                              }
                              else{
                                setState(() {
                                  _uidinvalid = false;
                                });
                              }
                            },
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

        ),
    );
  }
}
