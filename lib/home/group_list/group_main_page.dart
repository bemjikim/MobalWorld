import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobalworld/home/group_list/screens/archive_page.dart';
import 'package:mobalworld/home/group_list/screens/comunity_page.dart';
import 'package:mobalworld/home/group_list/screens/notification_page.dart';
import 'package:mobalworld/home/group_list/screens/profile_page.dart';
import 'package:mobalworld/home/group_list/screens/write_worry_page.dart';
import 'group_list_page.dart';

class GroupMainPage extends StatefulWidget {
  final String groupId; //그룹코드
  final String groupName; //페이지 명

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
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context)=>NotificationPage())
                );
              },
              icon: Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context)=>ArchivePage())
              );
            },
            icon: Icon(Icons.archive),
          ),
        ],
      ),
      body: Center(
        child: _getPage(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: '그룹 리스트',
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
        return ComunityPage(groupId: widget.groupId);
      case 1:
        return WriteWorryPage(groupId: widget.groupId,groupName: widget.groupName);
      case 2:
        return ProfilePage();
      default:
        return Container();
    }
  }
}
