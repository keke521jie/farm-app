import "dart:io";
import "package:app/base/kernel/Logger.dart";
import "package:app/base/store/AuthStore.dart";
import "package:app/uikit/getIt.dart";
import "dart:convert";
import "package:http/http.dart" as http;

/// 传一个文件然后传一个上传类型的字符串
Future<String> uploadImage(File imageFile, String type) async {
  var authStore = getIt<AuthStore>();
  var request = http.MultipartRequest(
    "POST",
    Uri.parse("https://farm.hswl007.com/api/dock/bucket?bucket=$type"),
  );

  // 添加文件
  request.files.add(
    await http.MultipartFile.fromPath(
      "file",
      imageFile.path,
    ),
  );

  // 设置请求头
  request.headers["Authorization"] = "token ${authStore.state.token}";

  // 发送请求
  var response = await request.send();

  final String responseString = await response.stream.bytesToString();
  var imgUrl = jsonDecode(responseString).cast<String>()[0];

  if (response.statusCode == 200) {
    logger.i("File uploaded successfully");
  } else {
    logger.i("File upload failed");
  }
  return imgUrl;
}
