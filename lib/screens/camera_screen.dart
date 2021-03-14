import 'package:flutter/material.dart';
import 'package:instagram_two_record/models/camera_state.dart';
import 'package:instagram_two_record/models/gallery_state.dart';
import 'package:instagram_two_record/widgets/my_gallery.dart';
import 'package:instagram_two_record/widgets/take_photo.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  CameraState _cameraState = CameraState();
  GalleryState _galleryState = GalleryState();

  @override
  _CameraScreenState createState() {
    _cameraState.getReadyToTakePhoto();
    _galleryState.initProvider();
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen> {
  int _currentIndex = 1;
  PageController _pageController = PageController(initialPage: 1);
  String _title = "Photo";

  @override
  void dispose() { //카메라 스크린이 버려지는 시기에 행해질 것들
    _pageController.dispose();
    widget._cameraState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CameraState>.value(value: widget._cameraState), // 이렇게 해주면 이 아래 위젯들은 다 이걸 사용 가능함
        ChangeNotifierProvider<GalleryState>.value(value: widget._galleryState), // 이렇게 해주면 이 아래 위젯들은 다 이걸 사용 가능함
        // ChangeNotifierProvider(create: (context) => CameraState()),  이렇게도 사용 가능함
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: PageView(
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
              switch(_currentIndex){
                case 0:
                  _title = "Gallery";
                  break;
                case 1:
                  _title = "Photo";
                  break;
                case 2:
                  _title = "Video";
                  break;
              }
            });
          },
          controller: _pageController,
          children: <Widget>[
            MyGallery(),
            TakePhoto(),
            Container(
              color: Colors.greenAccent,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 0,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.radio_button_checked),
              label: "GALLERY",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.radio_button_checked),
              label: "PHOTO",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.radio_button_checked),
              label: "VIDEO",
            ),
          ],
          currentIndex: _currentIndex,
          onTap: _onItemTabbed,
        ),
      ),
    );
  }

  void _onItemTabbed(index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
      );
    });
  }
}
