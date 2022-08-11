import 'dart:math' show pi;

import 'package:overlay_support/overlay_support.dart';
import 'package:shimmer/shimmer.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/global_env.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:rive/rive.dart'
    show RiveAnimation, OneShotAnimation, RiveAnimationController;

import 'package:voola/ui/styles/AppTheme.dart';
import 'package:voola/ui/views/wallet/WalletMainScreenModel.dart';

Widget gradientIcon(Widget icon) => ShaderMask(
    shaderCallback: AppColors.mainGradient.createShader,
    blendMode: BlendMode.srcIn,
    child: icon);

Widget textFieldActionsButton(
        {required Widget child, void Function()? onTap}) =>
    GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(padding: const EdgeInsets.all(8.0), child: child),
    );
InputDecoration generalTextFieldDecor(BuildContext context,
        {String? hintText,
        double? paddingRight,
        String? suffixText,
        Widget? prefixIcon}) =>
    InputDecoration(
      hintText: hintText,
      fillColor: AppColors.generalShapesBg,
      filled: true,
      prefixIcon: prefixIcon,
      prefixIconConstraints: BoxConstraints(maxWidth: 60, maxHeight: 52),
      contentPadding: EdgeInsets.fromLTRB(24, 17, paddingRight ?? 24, 17),
      isDense: true,
      isCollapsed: true,
      suffixText: suffixText,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.generalBorder, width: 1)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.generalBorder, width: 1)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.red, width: 1)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.active, width: 1)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.red, width: 1.5)),
    );
Widget shimmerBlock(double width, double height, double bradius) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
        color: Colors.black, borderRadius: BorderRadius.circular(bradius)));

class TBCCLoader extends StatefulWidget {
  bool builtin;

  TBCCLoader([this.builtin = false]);

  @override
  _TBCCLoaderState createState() => _TBCCLoaderState();
}

class _TBCCLoaderState extends State<TBCCLoader> {
  final riveFileName = 'assets/tbcc_loader.riv';
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OneShotAnimation('appearing', autoplay: true);
  }

  /// Show the rive file, when loaded
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.3;
    return Center(
        child: Container(
      width: width,
      height: width,
      child: RiveAnimation.asset(
        riveFileName,
        animations: const ['appearing'],
        controllers: [_controller],
        fit: BoxFit.contain,
      ),
    ));
  }
}

class Flushbar extends StatelessWidget {
  String title;
  String? subtitle;
  void Function()? action;
  Widget? leading;
  Color? bgColor;

  Flushbar(
      {required this.title,
      this.subtitle,
      this.bgColor,
      this.leading,
      this.action,
      Key? key})
      : super(key: key);

  Flushbar.success(
      {required this.title,
      this.subtitle,
      this.action,
      this.bgColor,
      this.leading}) {
    bgColor ??= AppColors.active.withOpacity(0.88);
    leading ??= Icon(Icons.check_outlined, color: bgColor);
  }
  Flushbar.error(
      {required this.title,
      this.subtitle,
      this.action,
      this.bgColor,
      this.leading}) {
    bgColor ??= AppColors.red.withOpacity(0.88);
    leading ??= Icon(Icons.error_outline, color: bgColor);
  }
  Flushbar.warning(
      {required this.title,
      this.subtitle,
      this.action,
      this.bgColor,
      this.leading}) {
    bgColor ??= Color(0xE0FCC419);
    leading ??= Icon(Icons.error_outline, color: bgColor);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        margin: const EdgeInsets.only(top: 60, right: 8, left: 8),
        child: Material(
          color: Colors.transparent,
          child: Theme(
            data: Theme.of(context),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (action != null) {
                  action?.call();
                  OverlaySupportEntry.of(context)?.dismiss(animate: false);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor ?? AppColors.active.withOpacity(0.88),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ListTile(
                    contentPadding: () {
                      //subtitle != null ? const EdgeInsets.fromLTRB(leading != null ? 12 : 22, 2, 12, 2) : const EdgeInsets.fromLTRB(22, 2, 12, 2),
                      double vertical = 10;
                      double left = 12;

                      if (subtitle != null) {
                        vertical = 2;
                      }
                      if (leading != null) {
                        left = 12;
                      }
                      return EdgeInsets.fromLTRB(left, vertical, 12, vertical);
                    }(),
                    leading: leading != null
                        ? Container(
                            padding: const EdgeInsets.all(12),
                            width: 52,
                            height: 52,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: leading,
                          )
                        : null,
                    title: Text('$title',
                        maxLines: subtitle != null ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.white)),
                    subtitle: subtitle != null
                        ? Text('$subtitle',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: Colors.white,
                                    fontSize: 14,
                                    height: 1.8))
                        : null,
                    trailing: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => OverlaySupportEntry.of(context)
                            ?.dismiss(animate: false))),
              ),
            ),
          ),
        ),
      ),
    );
  }

  OverlaySupportEntry show([Duration duration = const Duration(seconds: 2)]) =>
      showOverlayNotification((context) {
        return this;
      }, duration: duration);
}

class AnimatedOpacityWrapper extends StatefulWidget {
  final int index;
  final Widget child;
  final Duration duration;
  const AnimatedOpacityWrapper(
      {required this.child,
      this.index = 0,
      this.duration = const Duration(milliseconds: 400),
      Key? key})
      : super(key: key);

  @override
  _AnimatedOpacityWrapperState createState() => _AnimatedOpacityWrapperState();
}

class _AnimatedOpacityWrapperState extends State<AnimatedOpacityWrapper> {
  double _opacity = 0;
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: widget.index * 30), () {
      if (mounted)
        setState(() {
          _opacity = 1;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: widget.duration,
      child: widget.child,
    );
  }
}

class PremiumGlobalButton extends StatelessWidget {
  final bool active;
  final bool expanded;
  final String type;
  final bool shimmer;
  const PremiumGlobalButton(this.type, this.active, this.expanded,
      {this.shimmer = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: active ? null : AppColors.altGradient,
          color: active ? AppColors.primary : null,
          border: Border.all(
              width: 1, color: AppColors.inactiveText.withOpacity(0.1))),
      child: Row(
        children: [
          AppIcons.crown(20, active ? Colors.white : AppColors.text),
          if (expanded)
            shimmer
                ? Shimmer.fromColors(
                    baseColor: AppColors.inactiveText.withOpacity(0.3),
                    highlightColor: AppColors.active,
                    child: shimmerBlock(100, 16, 16),
                  )
                : Text(' $type',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: active ? Colors.white : AppColors.text)),
        ],
      ),
    );
  }
}

class CAppBar extends AppBar {
  CAppBar({
    Widget? title,
    Widget? leading,
    List<Widget>? actions,
    bool? centerTitle = false,
    double? elevation = 0,
    double? titleSpacing,
    Color? backgroundColor = Colors.transparent,
    Key? key,
  }) : super(
          key: key,
          title: title,
          actions: actions,
          leading: leading,
          elevation: elevation,
          backgroundColor: backgroundColor,
          centerTitle: centerTitle,
          titleSpacing: titleSpacing,
          backwardsCompatibility: false,
          toolbarHeight: 64,
          foregroundColor: AppColors.text,
        );
}

class CScaffold extends StatelessWidget {
  PreferredSizeWidget? appBar;
  Widget? body;
  Color? backgroundColor;
  CScaffold({this.appBar, this.backgroundColor, this.body, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      backgroundColor: backgroundColor ?? AppColors.primaryBg,
    );
  }
}

class AccountPNL extends StatelessWidget {
  final String value;
  final String percent;
  const AccountPNL(this.value, this.percent, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool negative = value.startsWith('-');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: (negative ? AppColors.red : AppColors.green).withOpacity(0.12),
      ),
      child: Text(
        "${negative ? '↓' : '↑'} $FIAT_CURRENCY_LITERAL$value  ($percent%)",
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: negative ? AppColors.red : AppColors.green),
      ),
    );
  }
}

class GradientLogo extends StatelessWidget {
  final Widget? child;

  const GradientLogo({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: AppColors.mainGradient.colors,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}

class Button extends StatelessWidget {
  String? value;
  bool isActive;
  void Function()? onTap;
  Color? color;
  bool isOutLine;
  Widget? leadingIcon;
  bool gradientBorder;
  Button(
      {Key? key,
      this.value,
      this.onTap,
      this.color,
      this.leadingIcon,
      this.isOutLine = false,
      this.gradientBorder = false,
      this.isActive = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        child: Stack(children: [
          Positioned.fill(
            child: Container(
              padding: gradientBorder ? const EdgeInsets.all(2) : null,
              decoration: gradientBorder
                  ? BoxDecoration(
                      gradient: AppColors.mainGradient,
                      borderRadius: BorderRadius.circular(16),
                    )
                  : null,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: onTap == null
                      ? AppColors.deActiveButton
                      : isOutLine
                          ? Colors.transparent
                          : color ?? Color(0xff4E94D7),
                  borderRadius: BorderRadius.circular(gradientBorder ? 14 : 16),
                  border: isOutLine
                      ? Border.all(width: 1, color: AppColors.primary)
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value!,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: onTap == null
                                ? AppColors.secondaryBG
                                : isActive
                                    ? gradientBorder
                                        ? AppColors.text
                                        : !isOutLine
                                            ? Colors.white
                                            : AppColors.primary
                                    : AppColors.inactiveText,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (leadingIcon != null)
            Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Align(
                    alignment: Alignment.centerLeft, child: leadingIcon!)),
        ]),
      ),
    );
  }
}

class IconButton_ extends StatelessWidget {
  Widget icon;
  void Function() onTap;
  IconButton_({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ShaderMask(
          shaderCallback: AppColors.mainGradient.createShader,
          child: Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white)),
            child: Center(child: icon),
          )),
    );
  }
}

class TextCard extends StatelessWidget {
  String? value;
  TextCard({Key? key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
          gradient: AppColors.mainGradient,
          borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: AppColors.primaryBg,
            borderRadius: BorderRadius.circular(11)),
        child: ShaderMask(
            child: Text(value!,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(fontSize: 16, color: Colors.white)),
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: AppColors.mainGradient.colors,
              ).createShader(bounds);
            }),
      ),
    );
  }
}

class InputContainer extends StatelessWidget {
  const InputContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.generalShapesBg),
      child: TextField(
        controller: null,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            hintText: 'Password',
            hintStyle:
                Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 16),
            border: InputBorder.none),
      ),
    );
  }
}

class RadioSelectorCircle extends StatelessWidget {
  final bool active;
  const RadioSelectorCircle({required this.active, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.inactiveText, width: 1.5)),
        child: active
            ? Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.active, width: 2.5)),
                child: null,
              )
            : null);
  }
}

class InnerPageTile extends StatelessWidget {
  final String? title;
  final String content;
  final List<Widget> actions;
  final double bradius;
  const InnerPageTile(this.title, this.content,
      {this.actions = const [], this.bradius = 24, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 20, actions.isEmpty ? 24 : 12, 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(bradius),
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.04)
              : AppColors.generalShapesBg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text('$title',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColors.inactiveText)),
            SizedBox(height: 8),
          ],
          Row(children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: actions.isEmpty ? 0 : 12),
                child: Text('$content',
                    style: Theme.of(context).textTheme.bodyText1),
              ),
            ),
            ...actions,
          ]),
        ],
      ),
    );
  }
}

class AnimatedButtonBar extends StatefulWidget {
  const AnimatedButtonBar(this.children, {Key? key}) : super(key: key);
  final List<ButtonBarEntry> children;
  @override
  _AnimatedButtonBarState createState() => _AnimatedButtonBarState();
}

class _AnimatedButtonBarState extends State<AnimatedButtonBar> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : AppColors.secondaryBG_gray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(fit: StackFit.loose, children: [
          AnimatedPositioned(
            top: 0,
            bottom: 0,
            left: constraints.maxWidth / widget.children.length * _index,
            right: (constraints.maxWidth / widget.children.length) *
                (widget.children.length - _index - 1),
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 18,
                      color: AppColors.shadowColor,
                      offset: Offset(0, 13)),
                ],
                color: AppColors.secondaryBG,
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
            ),
          ),
          Row(
            children: widget.children
                .asMap()
                .map((i, sideButton) {
                  print(i);
                  return MapEntry(
                    i,
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          try {
                            sideButton.onTap();
                          } catch (e) {
                            print('onTap implementation is missing');
                          }
                          var values = (1 == i
                              ? [
                                  ['BEP20', TokenFilterType.BEP20],
                                  ['ERC20', TokenFilterType.ERC20],
                                  ['BEP2', TokenFilterType.BEP2],
                                  ['BEP8', TokenFilterType.BEP8],
                                ]
                              : [
                                  ['Coins', TokenFilterType.Native],
                                ]);
                          setState(() {
                            locator<WalletMainScreenModel>().tokenFilterType =
                                values[0][1] as TokenFilterType;
                            _index = i;
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Center(
                            child: sideButton.child,
                          ),
                        ),
                      ),
                    ),
                  );
                })
                .values
                .toList(),
          ),
        ]);
      }),
    );
  }
}

class ButtonBarEntry {
  final Widget child;
  final VoidCallback onTap;
  final Color? activeColor;

  ButtonBarEntry({
    required this.child,
    required this.onTap,
    this.activeColor,
  });
}

class AccountSelector extends StatefulWidget {
  void Function(int) onSelected;
  int initIndex;
  AccountSelector(this.onSelected, {this.initIndex = 0, Key? key})
      : super(key: key);
  @override
  _AccountSelectorState createState() => _AccountSelectorState();
}

class _AccountSelectorState extends State<AccountSelector> {
  late AccountManager accManager;
  late int index;

  @override
  void initState() {
    index = widget.initIndex;
    accManager = locator<AccountManager>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        padding: EdgeInsets.zero,
        initialValue: index,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcons.wallet(20, AppColors.text),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                accManager.allAccounts[index].accountAlias,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Transform.rotate(
                angle: pi / 2, child: AppIcons.chevron(20, AppColors.text)),
          ],
        ),
        onSelected: (val) {
          if (index != val)
            setState(() {
              index = val;
            });
          widget.onSelected.call(val);
        },
        itemBuilder: (context) => accManager.allAccounts
            .asMap()
            .map(
              (key, value) => MapEntry(
                key,
                PopupMenuItem<int>(
                  value: key,
                  child: Text(value.accountAlias,
                      style: Theme.of(context).textTheme.subtitle1),
                ),
              ),
            )
            .values
            .toList());
  }
}
