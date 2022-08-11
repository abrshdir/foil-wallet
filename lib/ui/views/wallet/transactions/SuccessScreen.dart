import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:voola/shared.dart';
import 'package:url_launcher/url_launcher.dart';

class TxSuccessScreen extends StatelessWidget {
  final String hash;
  final String? explorerUrl;
  final void Function()? onTapOK;
  const TxSuccessScreen(this.hash, this.explorerUrl, this.onTapOK, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CScaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppIcons.transaction(70, AppColors.active),
                      SizedBox(height: 30),
                      Text(
                        S.of(context).transferSuccessText,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 20),
                      ),
                      SizedBox(height: 40),
                      Text('TxHash: '),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(text: hash));
                          Flushbar.success(
                                  title: S
                                      .of(context)
                                      .copiedToClipboard('Tx Hash'))
                              .show();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          children: [
                            Expanded(child: Text('$hash')),
                            SizedBox(width: 8),
                            AppIcons.copy(24, AppColors.active),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Button(
                value: 'Open in explorer...',
                onTap: () {
                  launch(explorerUrl!);
                },
                gradientBorder: true,
                color: AppColors.primaryBg,
              ),
              SizedBox(height: 12),
              Button(
                value: 'Back to wallet',
                onTap: () async {
                  Navigator.of(context).popUntil((route) => route.isFirst);

                  onTapOK?.call();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
