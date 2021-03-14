import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraState extends ChangeNotifier {
  CameraController _controller;
  CameraDescription _cameraDescription;
  bool _readyTakePhoto = false; //카메라 사용 준비가 되었을떄(컨트롤러가 초기화되었을때) true로 변경

  void dispose() {
    if(_controller != null)
      _controller.dispose();
    _controller = null;
    _cameraDescription = null;
    _readyTakePhoto = false;
    notifyListeners(); //해당데이터들이 변경되었다는걸 Consumer에게 알려줌
  }

  void getReadyToTakePhoto() async {
    List<CameraDescription> cameras = await availableCameras(); // 1) available 카메라 가져오기

    if (cameras != null && cameras.isNotEmpty) {
      setCameraDescription(cameras[0]); // 2) 첫번째 카메라 사용
    }

    bool init = false;
    while(!init) {
      init = await initialize();
    }

    _readyTakePhoto = true;
    notifyListeners(); // ChangeNotifier Provider로 데이터를 전달할때 Consumer나 Provider.of를 사용해서 데이터를 살펴보는 위젯들은
                       // 이 리스너를 통해 아 데이터 상태가 바뀌었구나 라는 알림을 받게 된다.

  }

    void setCameraDescription(CameraDescription cameraDescription) {
      _cameraDescription = cameraDescription;
      _controller = CameraController(_cameraDescription, ResolutionPreset.medium); // 3) 카메라컨트롤러 인스턴스 생성
    }

    Future<bool> initialize() async {
      try {
        await _controller.initialize();// 4) 초기화
        return true;
      }
      catch(e){
        return false;
      }
    }

    CameraController get controller => _controller;
    CameraDescription get description => _cameraDescription;
    bool get isReadyToTakePhoto => _readyTakePhoto; // 밖에서 이 파일의 데이터를 접근해서 고칠순 없고 get으로 가져가서 볼수만 있게게

}