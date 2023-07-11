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

class CurrentUser {
  final String name;

  CurrentUser({
    required this.name,
  });
}

class CurrentUserModel extends ChangeNotifier {
  final List<User> _currentUser = [];

  List<User> get currentUsers => _currentUser;

  void adduser(User name)
  {
    _currentUser.add(name);
    notifyListeners();
  }
  void removeUser(User name) {
    _currentUser.remove(name);
    notifyListeners();
  }
}
