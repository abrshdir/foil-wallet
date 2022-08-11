import 'dart:ui';

import 'package:voola/global_env.dart';
import 'package:voola/shared.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DAppBrowserScreen.dart';

class AlierDialogCustom extends StatelessWidget {
  AlierDialogCustom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16))),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          size: 95,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: 32),
                        Container(
                          child: Text(
                            'Attention',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 24),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.08),
                          child: Text(
                            'You are going to redirect to a third-party Dapp. When making this transfer, make sure that you are aware of the financial risks. SafePal is not responsible for any losses caused by the use of this Dapp.',
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: AppColors.text.withOpacity(0.7),
                                    ),
                          ),
                        ),
                        SizedBox(height: 24),
                        Button(
                          value: 'Open',
                          onTap: () {
                            return Navigator.pop(context, true);
                          },
                        ),
                        SizedBox(height: 12),
                        Button(
                          value: 'Close',
                          color: AppColors.inactiveText,
                          onTap: () {
                            return Navigator.pop(context, false);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 5,
              width: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AlierDialogModel extends BaseViewModel {}
