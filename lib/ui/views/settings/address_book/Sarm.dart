import 'package:voola/global_env.dart';
import 'package:voola/shared.dart';

class Sarm extends StatelessWidget {
  int mode;
  String? contactId;
  Sarm({this.mode = 1, this.contactId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SarmModel>(
      onModelReady: (model) {},
      builder: (context, model, child) {
        return CScaffold(
          appBar: CAppBar(
            elevation: 0,
            title: Text('Sarm'),
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

class SarmModel extends BaseViewModel {
  TokenNetworkInfoWrapper? network;
}
