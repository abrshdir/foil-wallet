import 'dart:io';

import 'package:local_auth/local_auth.dart';
import 'package:voola/core/settings/UserSettings.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/views/settings/SettingsMain.dart';
import 'package:voola/ui/views/settings/SettingsMainModel.dart';
import 'package:voola/ui/views/settings/security/Biometrics.dart';
import 'package:voola/ui/views/settings/security/PrivateKeys.dart';
import 'package:voola/ui/views/settings/security/smartCard/SmartCardAttach1.dart';
import 'package:voola/ui/views/start/SetPassword.dart';

import '../../../../core/authentication/AuthService.dart';
import '../../../../locator.dart';

class SecurityMainScreen extends StatefulWidget {
  const SecurityMainScreen({Key? key}) : super(key: key);

  @override
  _SecurityMainScreenState createState() => _SecurityMainScreenState();
}

class _SecurityMainScreenState extends State<SecurityMainScreen> {
  bool fingerprint = true;

  @override
  Widget build(BuildContext context) {
    return BaseView<SettingsMainModel>(
      onModelReady: (model) {
        model.checkingFaceOrFingerprint();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: CAppBar(
            elevation: 0,
            title: Text(S.of(context).securityCenter),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SettingsTile(
                    index: 2,
                    icon: gradientIcon(AppIcons.password(24)),
                    value: S.of(context).changePassword,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => SetPasswordScreen(
                              S.of(context).changePassword,
                              () => Navigator.of(context).pop(),
                              changePassword: true,
                            )))),
                if (!model.isFace && !model.isFingerprint)
                  SettingsTile(
                      index: 2,
                      icon: gradientIcon(AppIcons.fingerprint_scan(24)),
                      value: S.of(context).biometrics,
                      onTap: () {
                        /*
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => BiometricsScreen())),*/
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return BottomSheet(
                                onClosing: () {},
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (BuildContext context,
                                              setState) =>
                                          Container(
                                            decoration: new BoxDecoration(
                                                borderRadius: new BorderRadius
                                                        .only(
                                                    topLeft:
                                                        const Radius.circular(
                                                            100.0),
                                                    topRight:
                                                        const Radius.circular(
                                                            100.0))),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 12),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8),
                                                  child: Container(
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black12,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        if (model.isFingerprint)
                                                          Expanded(
                                                            child:
                                                                GestureDetector(
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            36,
                                                                        vertical:
                                                                            4),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: fingerprint
                                                                      ? Color(
                                                                          0xff4E94D7)
                                                                      : Colors
                                                                          .black12,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              24),
                                                                ),
                                                                child: Text(
                                                                  S
                                                                      .of(context)
                                                                      .fingerprint,
                                                                  style:
                                                                      TextStyle(
                                                                    color: fingerprint
                                                                        ? Colors
                                                                            .white
                                                                        : LightColors
                                                                            .text,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                setState(() {
                                                                  fingerprint =
                                                                      !fingerprint;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        if (model.isFace)
                                                          Expanded(
                                                            child:
                                                                GestureDetector(
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            36,
                                                                        vertical:
                                                                            4),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: !fingerprint
                                                                      ? Color(
                                                                          0xff4E94D7)
                                                                      : Color(
                                                                          0xffF4F7FC),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              24),
                                                                ),
                                                                child: Text(
                                                                  S
                                                                      .of(context)
                                                                      .faceDetection,
                                                                  style:
                                                                      TextStyle(
                                                                    color: !fingerprint
                                                                        ? Colors
                                                                            .white
                                                                        : LightColors
                                                                            .text,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                setState(() {
                                                                  fingerprint =
                                                                      !fingerprint;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                      ],
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                    ),
                                                  ),
                                                ),
                                                Divider(),
                                                SizedBox(
                                                  height: 36,
                                                ),
                                                Text(
                                                  fingerprint
                                                      ? S
                                                          .of(context)
                                                          .fingerprint
                                                      : S
                                                          .of(context)
                                                          .faceDetection,
                                                  style: TextStyle(
                                                    color: Color(0xff738390),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 36,
                                                ),
                                                fingerprint
                                                    ? AppIcons.fingerprint_scan(
                                                        160,
                                                        locator<UserSettings>()
                                                                .biometricsEnabled
                                                            ? AppColors.active
                                                            : AppColors
                                                                .inactiveText)
                                                    : AppIcons.face_detection(
                                                        160),
                                                SizedBox(
                                                  height: 36,
                                                ),
                                                Text(
                                                  fingerprint
                                                      ? S
                                                          .of(context)
                                                          .touchSensor
                                                      : S
                                                          .of(context)
                                                          .lookCamera,
                                                  style: TextStyle(
                                                    color: Color(0xff151F32),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 36,
                                                ),
                                                Button(
                                                  value: locator<UserSettings>()
                                                          .biometricsEnabled
                                                      ? S.of(context).disable
                                                      : S.of(context).enable,
                                                  onTap: () async {
                                                    await model
                                                        .switchBiometrics(
                                                            context);
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: OutlinedButton(
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16)),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text(
                                                      S.of(context).cancel,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff738390),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ));
                                },
                              );
                            });
                      }),
                SettingsTile(
                    index: 2,
                    icon: gradientIcon(
                        Icon(Icons.vpn_key_outlined, color: Colors.white)),
                    value: S.of(context).privateKeys,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => PrivateKeysScreen()));
                    }),
                if (!Platform.isIOS) ...[
                  SettingsTile(
                    icon: AppIcons.credit_card(24),
                    //value: I18n.of(context).smartCard,
                    value: 'Smart Card',
                    onTap: () {
                      if (locator<AuthService>()
                          .accManager
                          .allAccounts
                          .any((element) => element.cardAttached!)) {
                        Flushbar.error(
                          title: S.of(context).cardAttachedYet,
                        ).show(Duration(seconds: 4));

                        return;
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => SmartCardAttach1()));
                    },
                    index: 2,
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
