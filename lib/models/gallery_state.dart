import 'package:flutter/foundation.dart';
import 'package:local_image_provider/local_image.dart';
import 'package:local_image_provider/local_image_provider.dart';

class GalleryState extends ChangeNotifier {
  LocalImageProvider _localImageProvider;
  bool _hasPermission;
  List<LocalImage> _images;

  Future<bool> initProvider() async {
    _localImageProvider = LocalImageProvider();
    _hasPermission = await _localImageProvider.initialize(); //initialize가 Future로 반환

    if(_hasPermission) {
      _images = await _localImageProvider.findLatest(30); //device에서 30개를 가져와서 넣어줌
      notifyListeners(); //해당 갤러리 state를 살펴보고 있는 위젯들한테 image들 준비됐으니까 알아서 보고 디스플레이 바꿔줘 얘기해줌
      return true;
    } else {
      return false;
    }
  }

  List<LocalImage> get images => _images;
  LocalImageProvider get localImageProvider => _localImageProvider;
}