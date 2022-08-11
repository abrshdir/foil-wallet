import 'package:voola/shared.dart';
import 'DAppBrowserScreen.dart';
import 'DAppLaunchScreen.dart';

class DAppScreenModel extends BaseViewModel {
  int _indexToShow = 0;
  int get indexToShow => _indexToShow;
  set indexToShow(int val) {
    _indexToShow = val;
    setState();
  }

  late DAppBrowserScreenModel browserScreenModel;
  late DAppLaunchScreenModel launchScreenModel;
  DAppScreenModel() {
    browserScreenModel = DAppBrowserScreenModel();
    browserScreenModel.dappScreenModel = this;
    launchScreenModel = DAppLaunchScreenModel();
    launchScreenModel.dappScreenModel = this;
  }
}

class DAppScreen extends StatefulWidget {
  DAppScreen({Key? key}) : super(key: key);
  @override
  @override
  _DAppScreenState createState() => _DAppScreenState();
}

class _DAppScreenState extends State<DAppScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BaseView<DAppScreenModel>(
          onModelReady: (model) {},
          builder: (context, model, child) {
            return IndexedStack(
              index: model.indexToShow,
              children: [
                DAppLaunchScreen(model.launchScreenModel),
                DAppBrowserScreen(model.browserScreenModel),
                DAppLoadingScreen(model.launchScreenModel),
              ],
            );
          }),
    );
  }
}
