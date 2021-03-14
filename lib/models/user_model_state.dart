import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:instagram_two_record/models/firestore/user_model.dart';
import 'package:local_image_provider/local_album.dart';

class UserModelState extends ChangeNotifier {
  UserModel _userModel;
  StreamSubscription<UserModel> _currentStreamSub;

  UserModel get userModel => _userModel;

  //값 변경될때마다 알려주는 역할.
  set userModel(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }

  set currentStreamSub(StreamSubscription<UserModel> currentStreamSub) => _currentStreamSub;

  clear() async{
    if(_currentStreamSub != null)
      await _currentStreamSub.cancel();
    _currentStreamSub = null;
    _userModel = null;
  }

  bool amIFollowingThisUser(String otherUserKey) {
    if(_userModel == null || _userModel.followings == null || _userModel.followings.isNotEmpty)
      return false;
    else
    return _userModel.followings.contains(otherUserKey);
  }

}
