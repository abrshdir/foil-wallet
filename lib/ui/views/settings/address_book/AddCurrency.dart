import 'package:voola/global_env.dart';
import 'package:voola/shared.dart';

class AddCurrencyScreen extends StatelessWidget {
  int mode;
  String? contactId;
  AddCurrencyScreen({this.mode = 1, this.contactId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AddCurrencyModel>(
      onModelReady: (model) {},
      builder: (context, model, child) {
        return CScaffold(
          appBar: CAppBar(
            elevation: 0,
            title: Text('Add currency'),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'In develop...',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddCurrencyModel extends BaseViewModel {
  TokenNetworkInfoWrapper? network;
}
