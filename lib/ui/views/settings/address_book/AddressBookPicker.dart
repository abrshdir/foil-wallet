import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/core/token/utils.dart';
import 'package:voola/global_env.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/views/settings/address_book/AddressBook.dart';
import 'AddressBookModel.dart';

class AddressBookPickerScreen extends StatelessWidget {
  final TokenNetwork pickNetwork;
  AddressBookPickerScreen(this.pickNetwork, {Key? key}) : super(key: key);
  var myWallets = <AddressBookAddressEntity>[];
  var contacts = <AddressBookContactEntity>[];
  int expandedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BaseView<AddressBookModel>(
      onModelReady: (model) {},
      builder: (context, model, child) {
        switch (pickNetwork) {
          case TokenNetwork.BinanceChain:
            myWallets = [
              for (var acc in locator<AccountManager>().allAccounts)
                AddressBookAddressEntity()
                  ..address = acc.bcWallet.address!
                  ..description = acc.accountAlias
                  ..network = TokenNetwork.BinanceChain
            ];
            break;
          case TokenNetwork.BinanceSmartChain:
            myWallets = [
              for (var acc in locator<AccountManager>().allAccounts)
                AddressBookAddressEntity()
                  ..address = acc.bscWallet.address.hexEip55
                  ..description = acc.accountAlias
                  ..network = TokenNetwork.BinanceSmartChain
            ];
            break;
          case TokenNetwork.Ethereum:
            myWallets = [
              for (var acc in locator<AccountManager>().allAccounts)
                AddressBookAddressEntity()
                  ..address = acc.ethWallet.address.hexEip55
                  ..description = acc.accountAlias
                  ..network = TokenNetwork.Ethereum
            ];
            break;
          case TokenNetwork.Solana:
            myWallets = [
              for (var acc in locator<AccountManager>().allAccounts)
                AddressBookAddressEntity()
                  ..address = acc.solWallet.address
                  ..description = acc.accountAlias
                  ..network = TokenNetwork.Ethereum
            ];
            break;
          default:
        }

        contacts = model.contacts
            .where((element) => element.addresses
                .containsWhere((e) => e.network == pickNetwork))
            .toList();

        return CScaffold(
          appBar: CAppBar(
            elevation: 0,
            title: Text('Address book'),
          ),
          body: ListView(
            padding: EdgeInsets.all(16),
            children: [
              AddressBookPickerTile(
                expandedIndex == 0,
                AppIcons.logo(32),
                'My wallets',
                myWallets,
                () {
                  expandedIndex = 0;
                  model.setState();
                },
              ),
              SizedBox(height: 12),
              for (var i in contacts.asMap().entries)
                AddressBookPickerTile(
                  expandedIndex == i.key + 1,
                  Icon(Icons.person_outline, size: 32, color: AppColors.active),
                  i.value.name,
                  i.value.addresses
                      .where((element) => element.network == pickNetwork)
                      .toList(),
                  () {
                    expandedIndex = i.key + 1;
                    model.setState();
                  },
                )
            ],
          ),
        );
      },
    );
  }
}

class AddressBookPickerTile extends StatelessWidget {
  void Function() onTileTap;
  bool expanded;
  Widget icon;
  List<AddressBookAddressEntity> addrs;
  String title;

  AddressBookPickerTile(
      this.expanded, this.icon, this.title, this.addrs, this.onTileTap,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddressBookContactTile(icon, title, onTileTap, expanded: expanded),
        if (expanded)
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 12),
            child: Column(
                children: [
              for (var i in addrs) ...[
                AddressBookAddressTile(
                  i.description,
                  i.address,
                  NETWORKS_INFO[i.network]!.icon(32),
                  () => Navigator.of(context).pop(i.address),
                ),
              ]
            ].separate(SizedBox(height: 12))),
          )
      ],
    );
  }
}
