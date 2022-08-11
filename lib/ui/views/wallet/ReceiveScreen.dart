import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:voola/shared.dart';
import 'package:share_plus/share_plus.dart';

class ReceiveScreen extends StatelessWidget {
  final WalletToken token;
  final String address;
  const ReceiveScreen(this.token, this.address, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ReceiveScreenModel>(
      onModelReady: (model) {
        model.address = address;
        model.genQr();
      },
      builder: (context, model, __) => CScaffold(
        appBar: CAppBar(
          title: Text('${token.name} ${token.symbol}'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: QrImage.withQr(
                  qr: model.qr,
                  foregroundColor: AppColors.text,
                  size: MediaQuery.of(context).size.width * 0.5,
                ),
              ),
              SizedBox(height: 20),
              InnerPageTile(
                  'Network', token.network.toString().split('.').last),
              SizedBox(height: 10),
              InnerPageTile(
                S.of(context).address,
                address,
                actions: [
                  IconButton(
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: '$address'));
                        Flushbar.success(
                                title: S
                                    .of(context)
                                    .copiedToClipboard(S.of(context).address))
                            .show();
                      },
                      icon: ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: AppColors.mainGradient.createShader,
                          child: AppIcons.copy(24))),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Button(
                      value: S.of(context).share,
                      leadingIcon:
                          Icon(Icons.share, color: Colors.white, size: 26),
                      onTap: () async {
                        Share.share('$address');
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton_(
                    icon: AppIcons.qr_code(22, AppColors.text),
                    onTap: () async {
                      model.shareQRImage();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReceiveScreenModel extends BaseViewModel {
  late QrCode qr;
  late String address;
  void genQr() {
    qr = QrValidator.validate(
            data: '$address', errorCorrectionLevel: QrErrorCorrectLevel.H)
        .qrCode!;
  }

  shareQRImage() async {
    var directory = await getExternalStorageDirectory();
    var path = '${directory?.path}/qr.png';
    var file = File(path);

    await file.writeAsBytes(
        (await QrPainter.withQr(qr: qr, gapless: true, color: Colors.white)
                .toImageData(512))!
            .buffer
            .asUint8List());

    Share.shareFiles([path], mimeTypes: ['image/png'], subject: address);
  }
}
