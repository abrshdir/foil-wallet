import 'package:carousel_slider/carousel_slider.dart';
import 'package:voola/shared.dart';
import 'buyPro/BuyProView.dart';

import 'buyPremium/BuyPremiumView.dart';

class Pro_PremiumView extends StatelessWidget {
  bool discount;
  Pro_PremiumView({this.discount = false});
  @override
  Widget build(BuildContext context) {
    return CScaffold(
      //backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.primaryBgAlt
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(5, 16, 5, 32),
        child: Center(
          child: CarouselSlider(
            items: [
              Theme(
                data: DARK_THEME,
                child: MarketContainerPro(discount: discount),
              ),
              Theme(
                data: LIGHT_THEME,
                child: MarketContainerPremium(discount: discount),
              ),
            ],
            options: CarouselOptions(
              viewportFraction: 0.77,
              enableInfiniteScroll: false,
              height: () {
                var h = MediaQuery.of(context).size.height * 0.65;
                return h < 550.0 ? 550.0 : h;
              }(),
              enlargeCenterPage: true,
            ),
          ),
        ),
      ),
    );
  }
}

class MarketContainerPro extends StatefulWidget {
  bool discount;
  MarketContainerPro({this.discount = false});
  @override
  _MarketContainerProState createState() => _MarketContainerProState();
}

class _MarketContainerProState extends State<MarketContainerPro> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: DARK_THEME.backgroundColor,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ColorFiltered(
                      colorFilter:
                          ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      child: AppIcons.logo(24),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8, left: 10),
                      child: Text(
                        'TBCC',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, Colors.white60]),
                      ),
                      child: Text(
                        'PRO',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              for (var item in [
                S.of(context).accessToVpn,
                S.of(context).proDesc2h,
                //S.of(context).proDesc3h,
              ])
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: DarkColors.primaryBg),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Icon(
                                Icons.check,
                                color: AppColors.green,
                              ),
                            ),
                            Text(
                              '$item',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Button(
                value: S.of(context).purchasePro('PRO'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          BuyProScreen(mode: '1', discount: widget.discount)));
                },
              ),
              Button(
                  //valueColor: Colors.white,
                  color: Colors.transparent,
                  value: S.of(context).allFeatures,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            BuyProScreen(discount: widget.discount)));
                  }),
            ],
          )
        ],
      ),
    );
  }
}

class MarketContainerPremium extends StatefulWidget {
  bool discount;
  MarketContainerPremium({this.discount = false});
  @override
  _MarketContainerPremiumState createState() => _MarketContainerPremiumState();
}

class _MarketContainerPremiumState extends State<MarketContainerPremium> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.active.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ColorFiltered(
                      colorFilter:
                          ColorFilter.mode(Colors.black, BlendMode.srcIn),
                      child: AppIcons.logo(24),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8, left: 10),
                      child: Text(
                        'TBCC',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: DarkColors.primaryBg,
                      ),
                      child: Text(
                        'Premium',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              for (var item in [
                S.of(context).proDesc2h,
                //S.of(context).proDesc3h,
                S.of(context).proDesc4h,
              ])
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: AppColors.mainGradient),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Icon(
                                Icons.check,
                                color: AppColors.green,
                              ),
                            ),
                            Text(
                              '$item',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Button(
                  value: S.of(context).purchasePro('Premium'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BuyPremiumScreen(
                            mode: '1', discount: widget.discount)));
                  }),
              Button(
                  color: Colors.transparent,
                  value: S.of(context).allFeatures,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BuyPremiumScreen(
                            mode: '0', discount: widget.discount)));
                  }),
            ],
          )
        ],
      ),
    );
  }
}
