// import 'package:dio/dio.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';

import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'download_service.dart';
abstract class DownloadService {
  Future<void> download({required String url});
}

class WebDownloadService implements DownloadService {
  @override
  Future<void> download({required String url}) {
    throw UnimplementedError();
  }
}

class MobileDownloadService implements DownloadService {
  @override
  Future<void> download({required String url}) async {
    // requests permission for downloading the file
    bool hasPermission = await _requestWritePermission();
    if (!hasPermission) return;

    // gets the directory where we will download the file.
    var dir = await getExternalStorageDirectory();

    // You should put the name you want for the file here.
    // Take in account the extension.
    String fileName = 'myfile';

    // downloads the file
    Dio dio = Dio();
    await dio.download(url, "${dir?.path}/$fileName");

    // opens the file
    OpenFile.open("${dir?.path}/$fileName", type: 'application/pdf');
  }
  Future<bool> _requestWritePermission() async {
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  }
}