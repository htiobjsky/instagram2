import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:instagram_two_record/models/user_model_state.dart';
import 'package:instagram_two_record/screens/camera_screen.dart';
import 'package:instagram_two_record/screens/profile_screen.dart';
import 'package:instagram_two_record/screens/search_screen.dart';
import 'package:instagram_two_record/widgets/my_progress_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'constatns/screen_size.dart';
import 'screens/feed_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(); //상태변화가 생길때마다 새로운 State를 던져줌
}

class _HomePageState extends State<HomePage> {
  List<BottomNavigationBarItem> btmNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "kimgle"),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'bjsky'),
    BottomNavigationBarItem(icon: Icon(Icons.add), label: 'bjsky'),
    BottomNavigationBarItem(icon: Icon(Icons.healing), label: 'bjsky'),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'bjsky'),
  ];

  int _selectedIndex = 0;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  static List<Widget> _screens = <Widget>[
    Consumer<UserModelState>(builder:
        (BuildContext context, UserModelState userModelState, Widget child) {
      if (userModelState == null ||
          userModelState.userModel == null ||
          userModelState.userModel.followings == null ||
          userModelState.userModel.followings.isEmpty)
        return MyProgressIndicator();
      else return FeedScreen(userModelState.userModel.followings);
    }),
    SearchScreen(),
    Container(color: Colors.greenAccent),
    Container(color: Colors.deepOrangeAccent),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    if (size == null)
      size = MediaQuery.of(context).size; //우리가 사용하고있는 디바이스의 화면사이즈를 가져옴
    return Scaffold(
      key: _key,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: btmNavItems,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black87,
        currentIndex: _selectedIndex,
        onTap: _onBtmItemClick,
      ),
    );
  }

  void _onBtmItemClick(int index) {
    switch (index) {
      case 2:
        _openCamera();
        break;
      default:
        {
          print(index);
          setState(() {
            _selectedIndex = index;
          });
        }
    }
  }

  void _openCamera() async {
    if (await checkIfPermissionGranted(context)) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CameraScreen()),
      );
    } else {
      SnackBar snackBar = SnackBar(
        content: Text('사진, 파일, 마이크 접근 허용 해주셔야 카메라 사용이 가능합니다'),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {
            _key.currentState.hideCurrentSnackBar();
            AppSettings.openAppSettings();
          },
        ),
      );
      _key.currentState.showSnackBar(snackBar);
    }
  }

  Future<bool> checkIfPermissionGranted(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.photos
    ].request();
    bool permitted = true;

    statuses.forEach((permission, permissionstatus) {
      if (!permissionstatus.isGranted) permitted = false;
    });

    return permitted;
  }
}
