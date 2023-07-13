import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase/firebase_options.dart';
import 'login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // 옵션 설정도 중요
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => Email(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Namer App',
        theme: ThemeData(
          fontFamily: 'gangwon',
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black26),
        ),
        home: LoginPage(),
      ),
    );
  }
}

class EmailUser {
  final String name;

  EmailUser({
    required this.name,
  });
}

class Email with ChangeNotifier {
  String _email = "";

  String getEmail() => _email;

  void add(String email) {
    _email = email;
    notifyListeners();
  }

  void remove() {
    _email = "";
    notifyListeners();
  }
}