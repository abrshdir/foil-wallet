import 'package:flutter/services.dart';
import 'package:voola/core/authentication/AuthService.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:web3dart/crypto.dart';

class PrivateKeysScreen extends StatefulWidget {
  PrivateKeysScreen({Key? key}) : super(key: key);

  @override
  _PrivateKeysScreenState createState() => _PrivateKeysScreenState();
}

class _PrivateKeysScreenState extends State<PrivateKeysScreen> {
  int selectedAcc = 0;

  @override
  Widget build(BuildContext context) {
    var accManager = locator<AuthService>().accManager;
    return CScaffold(
      appBar: CAppBar(
        title: Text(S.of(context).privateKeys),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AccountSelector((index) {
              setState(() {
                selectedAcc = index;
              });
            }),
            SizedBox(height: 16),
            Tile(
                header: S.of(context).mnemonicPhrase,
                value: accManager.allAccounts[selectedAcc].mnemonic),
            Tile(
                header: S.of(context).binancePK,
                value:
                    accManager.allAccounts[selectedAcc].bcWallet.privateKey!),
            Tile(
                header: S.of(context).ethereumPK,
                value: bytesToHex(accManager
                    .allAccounts[selectedAcc].ethWallet.privateKey.privateKey)),
            Tile(
                header: 'Binance Smart Chain',
                value: bytesToHex(accManager
                    .allAccounts[selectedAcc].bscWallet.privateKey.privateKey)),
          ],
        ),
      ),
    );
  }
}

class Tile extends StatefulWidget {
  String header, value;

  Tile({required this.header, required this.value, Key? key}) : super(key: key);

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> with TickerProviderStateMixin {
  late bool expanded;

  @override
  void initState() {
    expanded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.generalShapesBg,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              children: [
                Text(widget.header,
                    style: Theme.of(context).textTheme.bodyText1),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(S.of(context).show,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: AppColors.active)),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.active,
                )
              ],
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              alignment: Alignment.topCenter,
              curve: Curves.easeIn,
              vsync: this,
              child: Container(
                padding: const EdgeInsets.all(20),
                constraints: BoxConstraints(
                    minHeight: 0,
                    maxHeight: expanded ? 400 : 0,
                    maxWidth: MediaQuery.of(context).size.width),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${widget.value}\n',
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(
                            ClipboardData(text: widget.value));
                        Flushbar.success(
                                title: S.of(context).copiedToClipboard(''))
                            .show();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.copy_rounded),
                            Text(S.of(context).copy)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
