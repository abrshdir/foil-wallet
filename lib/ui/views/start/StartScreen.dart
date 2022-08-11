import 'package:voola/shared.dart';
import 'package:voola/ui/views/start/CreateWallet.dart';
import 'package:voola/ui/views/start/RestoreWallet.dart';

class StartScreen extends StatelessWidget {
  bool addWallet;
  StartScreen({this.addWallet = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CScaffold(
        appBar: addWallet ? CAppBar() : null,
        body: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Spacer(flex: 7),
                AppIcons.logo(200),
                Spacer(flex: 2),
                Text(
                  'INFINITY IS VOOLA!',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontSize: 28,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                Spacer(flex: 2),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.08,
                  ),
                  child: Text(
                    'Buy, stire, send, exchange your cryptocurrency with an easy-to-use and convinient wallet',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: AppColors.text.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacer(flex: 7),
                Button(
                  value: S.of(context).createWallet,
                  onTap: () => Navigator.of(context).push(PageTransition(
                      child: CreateWalletScreen(addWallet: addWallet),
                      type: PageTransitionType.rightToLeft)),
                ),
                SizedBox(height: 12),
                Button(
                  value: S.of(context).restoreWallet,
                  isActive: false,
                  color: Colors.transparent,
                  onTap: () => Navigator.of(context).push(PageTransition(
                      child: RestoreWalletScreen(addWallet: addWallet),
                      type: PageTransitionType.rightToLeft)),
                ),
              ],
            ),
          ),
        ));
  }
}
