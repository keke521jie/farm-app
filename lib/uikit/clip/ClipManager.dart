import "dart:io";

import "package:archive/archive_io.dart";
import "package:dio/dio.dart";
import "package:logging/logging.dart";
import "package:path_provider/path_provider.dart";
import "package:logger/logger.dart" as logg;

import "Version.dart";

class PluginManager {

  config() {}

  /// 启动小程序
  /// [request] 启动小程序的request
  Future<Map> start(StartRequest request) {
    return Future.value();
  }

  /// 关闭指定的小程序
  /// @param appletId 小程序id
  /// @param animated 是否显示动画，仅iOS生效
  Future<void> close(String appletId, bool animated) async {
    return Future.value();
  }

  /// 关闭打开的所有小程序
  Future closeAll() {
    return Future.value();
  }

  /// 结束小程序 小程序会从内存中清除
  Future<void> finish(String appletId, bool animated) {
    return Future.value();
  }

  /// 清除指定的小程序本体缓存
  Future remove(String appId) {
    return Future.value();
  }

  /// 清除所有小程序缓存
  Future removeAll() {
    return Future.value();
  }
}

class StartRequest {
  StartRequest(this.appId, this.apiServer, this.startParams);

  String appId;
  String apiServer;
  String startParams;
}

class ClipVersionInfo {
  ClipVersionInfo(this.version, this.url);

  Version version;
  String url;
}

class ClipUtil {
  static Logger logger = Logger("clip");
  static final Dio _dio = Dio();

  static baseDirectory() async {
    Directory directory = await getApplicationSupportDirectory();
    Directory pluginsDir = Directory("${directory.path}/clips");
    return await pluginsDir.create(recursive: true);
  }

  Future<ClipVersionInfo?> getLatestVersion(String apiServer, Version appVersion, Version clipVersion) async {
    var url = "$apiServer/latest";
    final response = await _dio.get(url);
    if(response.statusCode != 200) {
      logger.severe("get latest version failed");
      return null;
    }

    var data = response.data;
    logger.info("latest version", data);
    return ClipVersionInfo(Version.parse(data.version), data.url);
  }

  Future<String> install(String url) async {
    String fileName = url.split("/").last;
    String folderName = fileName.split(".").first;

    Directory directory = await baseDirectory();
    File zipFile = File("${directory.path}/$fileName");
    if (zipFile.existsSync()) {
      zipFile.deleteSync();
    }

    final destinationDir = Directory("${directory.path}/$folderName");

    File indexFile = File("${destinationDir.path}/index.html");
    if (indexFile.existsSync()) {
      return "file://${indexFile.path}#/connectBlue";
    }

    if (destinationDir.existsSync()) {
      print("Deleting existing unzip directory: ${destinationDir.path}");
      destinationDir.deleteSync(recursive: true);
    }

    destinationDir.createSync();
    logger.info("destinationDir: $destinationDir");

    Response response = await _dio.download(url, zipFile.path);

    await extractFileToDisk(zipFile.path, destinationDir.path);

    logger.info("解压成功, destinationDir: $destinationDir");

    logger.info("download success, path: ${zipFile.path}");
    logger.info("${indexFile.path} ${indexFile.existsSync()}");
    return "file://${indexFile.path}#/connectBlue";
  }

  Future<String> isInstall(String url) async {
    if (url == "") {
      return Future.error("url was empty");
    }
    String fileName = url.split("/").last;
    String folderName = fileName.split(".").first;

    Directory directory = await baseDirectory();
    File zipFile = File("${directory.path}/$fileName");
    if (zipFile.existsSync()) {
      zipFile.deleteSync();
    }

    final destinationDir = Directory("${directory.path}/$folderName");
    File indexFile = File("${destinationDir.path}/index.html");
    if (indexFile.existsSync()) {
      return "file://${indexFile.path}#/connectBlue";
    }
    return Future.error("file not exists");
  }

}
