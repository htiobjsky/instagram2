import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:instagram_two_record/constatns/common_size.dart';
import 'package:instagram_two_record/constatns/screen_size.dart';
import 'package:instagram_two_record/models/camera_state.dart';
import 'package:instagram_two_record/models/user_model_state.dart';
import 'package:instagram_two_record/repo/helper/generate_post_key.dart';
import 'package:instagram_two_record/screens/share_post_screen.dart';
import 'package:instagram_two_record/widgets/my_progress_indicator.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class TakePhoto extends StatefulWidget {
  const TakePhoto({
    Key key,
  }) : super(key: key);

  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  Widget _progress = MyProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return Consumer<CameraState>(
      builder: (BuildContext context, CameraState cameraState, Widget child) {
        return Column(
          children: [
            Container(
              width: size.width,
              height: size.width,
              color: Colors.black,
              child: (cameraState.isReadyToTakePhoto)
                  ? _getPreview(cameraState)
                  : _progress,
            ),
            Expanded(
              child: OutlineButton(
                shape: CircleBorder(),
                onPressed: () {
                  if (cameraState.isReadyToTakePhoto) {
                    _attempTakePhoto(cameraState, context);
                  }
                },
                borderSide: BorderSide(
                  color: Colors.black12,
                  width: 20,
                ),
              ),
              // child: InkWell( //클릭을 할수있게 해줌
              //   onTap: () {},
              //   child: Padding(
              //     padding: const EdgeInsets.all(common_s_gap),
              //     child: Container(
              //       decoration: ShapeDecoration(
              //         shape: CircleBorder(
              //           side: BorderSide(
              //             color: Colors.black12,
              //             width: 20,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ),
          ],
        );
      },
    );
  }

  Widget _getPreview(CameraState cameraState) {
    return ClipRect(
      // Overflow된 부분을 잘라줌
      child: OverflowBox(
        // child 위젯이 정해진 크기 밖으로 나갈수있게끔 해줌
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Container(
            width: size.width,
            height: size.width * cameraState.controller.value.aspectRatio,
            child: CameraPreview(
              cameraState.controller,
            ),
          ),
        ),
      ),
    );
  }

  void _attempTakePhoto(CameraState cameraState, BuildContext context) async {
    final String postKey = getNewPostKey(
        Provider.of<UserModelState>(context, listen: false).userModel);
    try {
      // final path = join( (await getTemporaryDirectory()).path, '$postKey.png');
      XFile picturetaken = await cameraState.controller.takePicture();

      File imageFile = File(picturetaken.path); //이미지 파일 생성
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => SharePostScreen(
                imageFile,
                postKey: postKey,
              )));
    } catch (e) {}
  }
}
