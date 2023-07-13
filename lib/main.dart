import 'dart:async';

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
      create: (context) => CurrentUserModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Namer Apps-junghyun',
        theme: ThemeData(
          fontFamily: 'gangwon',
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black26),
        ),
        home: LoadingPage(),
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Image.asset('assets/images/doosan.jpeg',width: 200,height: 200,alignment: Alignment.center,),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrentUser {
  final String name;

  CurrentUser({
    required this.name,
  });
}

class CurrentUserModel extends ChangeNotifier {
  final List<User> _currentUser = [];

  List<User> get currentUsers => _currentUser;

  void adduser(User name) {
    _currentUser.add(name);
    notifyListeners();
  }

  void removeUser(User name) {
    _currentUser.remove(name);
    notifyListeners();
  }
}
