import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:instagram_two_record/models/gallery_state.dart';
import 'package:instagram_two_record/models/user_model_state.dart';
import 'package:instagram_two_record/repo/helper/generate_post_key.dart';
import 'package:instagram_two_record/screens/share_post_screen.dart';
import 'package:local_image_provider/device_image.dart';
import 'package:local_image_provider/local_image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class MyGallery extends StatefulWidget {
  @override
  _MyGalleryState createState() => _MyGalleryState();
}

class _MyGalleryState extends State<MyGallery> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GalleryState>(
      builder: (BuildContext context, GalleryState galleryState, Widget child) {
        return GridView.count(
          crossAxisCount: 3,
          children: getImages(context, galleryState),
        );
      },
    );
  }

  List<Widget> getImages(BuildContext context, GalleryState galleryState) {
    return galleryState.images
        .map((localImage) => InkWell(
          onTap: () async {
            Uint8List bytes = await localImage.getScaledImageBytes(galleryState.localImageProvider, 0.3);
            final String postKey = getNewPostKey(Provider.of<UserModelState>(context, listen: false).userModel);
            // final String timeInMill = DateTime.now().millisecondsSinceEpoch.toString(); // 이미지 저장시 이미지명으로 사용
            try {
              final path = join( (await getTemporaryDirectory()).path, '$postKey.png');
              // XFile picturetaken = await cameraState.controller.takePicture();

              File imageFile = File(path)..writeAsBytesSync(bytes); //이미지 파일 생성
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => SharePostScreen(imageFile, postKey: postKey,)));
            } catch(e) {

            }

          },
          child: Image(
                image: DeviceImage(localImage, scale: 0.2),
                fit: BoxFit.cover,
              ),
        ))
        .toList();
  }


}
