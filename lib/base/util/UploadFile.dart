import "dart:io";
import "package:app/base/kernel/Logger.dart";
import "package:image_picker/image_picker.dart";

import "UploadImg.dart";

class UploadFile {
  File? _image;
  Future<String> cameraUpload() async {
    // 拍照上传
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      logger.i(_image);
    } else {
      print("No image selected.");
    }

    if (_image != null) {
      // 上传图片
      var imgUrl = await uploadImage(_image!, "problem");
      return imgUrl;
    }
    return "";
  }

  Future<String> imgUpload() async {
    // 选择上传
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      logger.i(_image);
    } else {
      print("No image selected.");
    }

    if (_image != null) {
      // 上传图片
      var imgUrl = await uploadImage(_image!, "problem");
      return imgUrl;
    }
    return "";
  }
}

UploadFile uploadFile = UploadFile();
