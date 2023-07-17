import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobalworld/home/group_list/screens/archive_page.dart';
import 'package:mobalworld/home/group_list/screens/notification_page.dart';
import 'package:mobalworld/home/group_list/screens/profile_page.dart';
import 'package:mobalworld/home/group_list/screens/write_worry_page.dart';

import 'group_list_page.dart';

class GroupMainPage extends StatefulWidget {
  final String groupId;
  final String groupName;

  GroupMainPage({required this.groupId, required this.groupName});

  @override
  State<GroupMainPage> createState() => _GroupMainPageState();
}

class _GroupMainPageState extends State<GroupMainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  Expanded(
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new,
                  color: Color(0xFF72614E)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupListPage(),
                  ),
                );
              },
            )
        ),
        title: Text(
          widget.groupName,
          style: TextStyle(
            fontWeight: FontWeight.w600
          ),
        ),
        //elevation: 4,
      ),
      body: Center(
        child: _getPage(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '알림',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive),
            label: '보관함',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: '고민작성',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '프로필',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black, // 선택된 항목의 아이콘과 라벨 색상
        unselectedItemColor: Colors.grey, // 선택되지 않은 항목의 아이콘과 라벨 색상
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return NotificationPage();
      case 1:
        return ArchivePage();
      case 2:
        return WriteWorryPage();
      case 3:
        return ProfilePage();
      default:
        return Container();
    }
  }
}
