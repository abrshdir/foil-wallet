import 'package:voola/core/settings/UserSettings.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _settings = locator<UserSettings>();

    return CScaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(''),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
            child: AppIcons.logo(60),
          ),
          Text(
            "TBCC Wallet\n",
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: AppColors.text,
                ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.08,
              vertical: 25,
            ),
            child: Text(
              "2022 UAB Labaratory of Seven Possibilities operates VOOLA Platform is registered under number 306026599 by the State Enterprise Centre of Registers of the Republic of Lithuania as a provider of activities of a virtual currency exchange operator.",
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: AppColors.text,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            "v. ${_settings.versionName} (${_settings.versionCode})",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: AppColors.text,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
