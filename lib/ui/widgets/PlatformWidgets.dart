import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/core/authentication/AuthService.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';

import 'package:voola/ui/styles/AppTheme.dart';
import 'package:voola/ui/views/premium/Pro_Premium.dart';

class PlatformTabScaffold extends StatefulWidget {
  List<BottomNavigationBarItem> bottomItems;
  List<Widget> bodyItems;

  PlatformTabScaffold(
      {required this.bottomItems, required this.bodyItems, Key? key})
      : super(key: key);

  @override
  PlatformTabScaffoldState createState() => PlatformTabScaffoldState();
}

class PlatformTabScaffoldState extends State<PlatformTabScaffold> {
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  //toPage(index) {
  //  if (index == 1) {
  //    if (locator<AuthService>().accountManager.accType != AccountType.Free) {
  //      setState(() {
  //        bottomSelectedIndex = index;
  //        pageController.animateToPage(index, duration: Duration(milliseconds: 1), curve: Curves.ease);
  //      });
  //    } else {
  //      Navigator.of(context).push(MaterialPageRoute(builder: (_) => Pro_PremiumView()));
  //    }
  //  } else {
  //    setState(() {
  //      bottomSelectedIndex = index;
  //      pageController.animateToPage(index, duration: Duration(milliseconds: 1), curve: Curves.ease);
  //    });
  //  }
  //}
  toPage(index) {
    if (index == 2) {
      if (locator<AuthService>().accManager.accountType != AccType.Free) {
        setState(() {
          bottomSelectedIndex = index;
          pageController.animateToPage(index,
              duration: Duration(milliseconds: 1), curve: Curves.ease);
        });
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => Pro_PremiumView()));
      }
    } else {
      setState(() {
        bottomSelectedIndex = index;
        pageController.animateToPage(index,
            duration: Duration(milliseconds: 1), curve: Curves.ease);
      });
    }
  }

  int bottomSelectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoTabScaffold(
        backgroundColor: Colors.white,
        tabBar: CupertinoTabBar(
          backgroundColor: AppColors.primaryBg,
          items: widget.bottomItems,
          activeColor: AppColors.green,
          border: Border(
              top: BorderSide(
                  color: AppColors.inactiveText.withOpacity(0.5), width: 0.0)),
        ),
        tabBuilder: (context, index) {
          return widget.bodyItems[index];
        },
      );
    } else {
      return Scaffold(
          backgroundColor: Colors.transparent,
          body: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  bottomSelectedIndex = index;
                });
              },
              children: widget.bodyItems),
          bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                showSelectedLabels: true,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                selectedItemColor: AppColors.active,
                unselectedItemColor: AppColors.inactiveText,
                backgroundColor: AppColors.primaryBg,
                currentIndex: bottomSelectedIndex,
                //unselectedLabelStyle: Theme.of(context).textTheme.caption!.copyWith(fontSize: 0, height: 0),
                //selectedLabelStyle: Theme.of(context).textTheme.caption!.copyWith(fontSize: 0, height: 0),
                unselectedLabelStyle: Theme.of(context).textTheme.caption,
                selectedLabelStyle: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: AppColors.active),
                onTap: toPage,
                items: widget.bottomItems,
              )));
    }
  }
}
