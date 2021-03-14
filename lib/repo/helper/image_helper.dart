import 'dart:io';
import 'package:image/image.dart';

File getResizedImage(File originImage) { //오리지널 파일을 받아와서
  Image image = decodeImage(originImage.readAsBytesSync()); //image를 byte로 읽어와서 decode해서 image 오브젝트로 만들어줌.
  Image resizedImage = copyResizeCropSquare(image, 300); // 이미지를 정사각형 형태로 만들고 사이즈를 줄여줌

  //png 파일을 jpg로 변경해서 저장
  File resizedFile = File(originImage.path.substring(0, originImage.path.length-3)+"jpg");
  resizedFile.writeAsBytesSync(encodeJpg(resizedImage, quality: 50)); //퀄리티도 50%로 떨어뜨려서 JPG로 만들어줌
  return resizedFile;
}