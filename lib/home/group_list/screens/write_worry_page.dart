import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WriteWorryPage extends StatefulWidget {
  const WriteWorryPage({Key? key}) : super(key: key);

  @override
  State<WriteWorryPage> createState() => _WriteWorryPageState();
}

class _WriteWorryPageState extends State<WriteWorryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("고민작성페이지입니다"),
      ),
    );
  }
}
