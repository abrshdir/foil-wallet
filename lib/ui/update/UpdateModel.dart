import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/digests/md5.dart' as md5;
import 'package:hex/hex.dart' as hex;
import 'package:voola/core/api/tbcc/models/Update.dart';
import 'package:voola/core/settings/UserSettings.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';

class UpdateViewModel extends BaseViewModel {
  UpdateViewModel();

  /// 0 = no update
  /// 1 = need to download update
  /// 2 = downloading
  /// 3 = checking md5 after download
  /// 4 = able to install update

  int updateState = 0;

  final _userSettings = locator<UserSettings>();
  late Directory downloadDir;
  late InnerUpdate info;
  double downloadedPercent = 0;
  Future<void> checkUpdate() async {
    print(_userSettings.versionCode);
    setState(ViewState.Busy);
    info = _userSettings.update;
    downloadDir = (await getExternalStorageDirectory())!;
    var existsApkFile = (await downloadDir.list().toList()).firstWhereMaybe(
      (element) => element.path.split('/').last.startsWith('voola'),
      orElse: () => null,
    );
    if (existsApkFile != null) {
      int fileVer = int.tryParse(existsApkFile.path
              .split('/')
              .last
              .split('-')
              .last
              .split('.')
              .first) ??
          -1;
      if (fileVer < _userSettings.update.actualVersion! ||
          fileVer <= int.parse(_userSettings.versionCode)) {
        await existsApkFile.delete();
      } else {
        var data = await File(existsApkFile.path).readAsBytes();
        var md5hash = await compute(calculateMd5, data);
        if (md5hash == info.md5) {
          updateState = 4;
          setState(ViewState.Idle);
          return;
        } else {
          await existsApkFile.delete();
        }
      }
    }
    if (_userSettings.update.actualVersion! >
        int.parse(_userSettings.versionCode)) {
      //if (100 > int.parse(_userSettings.versionCode)) {
      updateState = 1;
      setState(ViewState.Idle);
      return;
    }
    setState(ViewState.Idle);
  }

  Future<void> downloadUpdate(context) async {
    updateState = 2;
    setState();
    int downloaded;
    List<List<int>> chunks = <List<int>>[];
    var client = http.Client();

    var request = http.Request('GET', Uri.parse(info.url!));
    downloaded = 0;
    var response = client.send(request);

    response.asStream().listen((http.StreamedResponse r) {
      r.stream.listen((List<int> chunk) {
        // Display percentage of completion
        downloadedPercent = downloaded / r.contentLength! * 100;
        setState();
        chunks.add(chunk);
        downloaded += chunk.length;
      }, onDone: () async {
        File file =
            new File('${downloadDir.path}/${info.url!.split('/').last}');
        final Uint8List bytes = Uint8List(r.contentLength!);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        var md5hash = await compute(calculateMd5, bytes);
        if (md5hash == info.md5) {
          await file.writeAsBytes(bytes);
          updateState = 4;
          setState();
          return;
        } else {
          updateState = 5;
          setState();
          return;
        }
      });
    });
  }

  Future<void> installUpdate() async {
    InstallPlugin.installApk(downloadDir.path + '/${info.url!.split('/').last}',
            'com.wirelessenergy.voola')
        .then((result) {})
        .catchError((error) {});
  }
}

Future<String> calculateMd5(Uint8List data) async {
  return hex.HEX.encode(md5.MD5Digest().process(data));
}
