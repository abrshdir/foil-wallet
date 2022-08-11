import 'package:binance_chain/binance_chain.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solana/solana.dart' as sol;
import 'package:voola/core/token/utils.dart';
import 'package:voola/global_env.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/QrCodeReader.dart';
import 'package:voola/ui/views/settings/address_book/AddressBookModel.dart';

import 'AddCurrency.dart';

class AddContactScreen extends StatelessWidget {
  int mode;
  String? contactId;
  AddContactScreen({this.mode = 1, this.contactId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AddContactModel>(
      onModelReady: (model) {
        model.mode = mode;
        model.contactId = contactId;
      },
      builder: (context, model, child) {
        return CScaffold(
          appBar: CAppBar(
            elevation: 0,
            title: Text(mode == 1 ? 'Add contact' : 'Add address'),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: model.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (mode == 1) ...[
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: model.controllerName,
                            validator: (val) {
                              if (val!.length < 1) {
                                return 'Too short';
                              }
                            },
                            decoration: generalTextFieldDecor(context,
                                hintText: 'Name'),
                          ),
                        ],
                        SizedBox(height: 8),
                        TextFormField(
                          controller: model.controllerAddress,
                          validator: (val) =>
                              model.isAddrValid(val ?? '', context)
                                  ? null
                                  : S.of(context).wrongAddr,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: generalTextFieldDecor(
                            context,
                            paddingRight: 44,
                            hintText: S.of(context).address,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: model.controllerNote,
                          decoration:
                              generalTextFieldDecor(context, hintText: 'Note'),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: Text(
                            'Currency',
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      fontSize: 20,
                                    ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                child: AddCurrencyScreen(),
                              ),
                            );
                          },
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryBG,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 18,
                                    color: AppColors.shadowColor,
                                    offset: Offset(0, 13))
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: SvgPicture(
                                      AppIcons.plus_circle(21).pictureProvider,
                                      allowDrawingOutsideViewBox: true,
                                      width: 16,
                                      height: 16,
                                      fit: BoxFit.contain,
                                      colorFilter: ColorFilter.mode(
                                        AppColors.primary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text('Add currency'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 10,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        // AddressBookContactTile(
                        //     model.network!.icon(28), model.network!.name, () async {
                        //   var network = await Navigator.of(context).push(
                        //       PageTransition(
                        //           type: PageTransitionType.rightToLeftWithFade,
                        //           child: NetworkSelectorScreen()));
                        //   if (network != null) {
                        //     model
                        //       ..network = network
                        //       ..setState();
                        //   }
                        // }),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.bottomCenter,
                  child: Button(
                    value: 'Save',
                    onTap: () {
                      if (model.formKey.currentState?.validate() == true) {
                        model.addContact();
                        Navigator.of(context).pop();
                      }
                    },
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

class AddContactModel extends BaseViewModel {
  final controllerName = TextEditingController();
  final controllerNote = TextEditingController();
  final controllerAddress = TextEditingController();
  final formKey = GlobalKey<FormState>();
  TokenNetworkInfoWrapper? network;

  /// 1 = new contact
  /// 2 = add address to contact
  int mode = 1;

  /// need when mode = 2
  String? contactId;

  String? name;
  String? note;
  String? address;
  AddContactModel() {
    network = NETWORKS_INFO.entries.first.value;
  }

  Future<void> scanAddressQr(context) async {
    var qr = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => QRCodeReader()));
    if (isAddrValid(qr, context)) {
      address = qr;
      controllerAddress.text = address!;
    } else {
      Flushbar.error(title: S.of(context).noValidAddrFound).show();
    }
  }

  bool isAddrValid(String val, context) {
    switch (network!.network) {
      case TokenNetwork.BinanceChain:
        return validateAddress(val);
      case TokenNetwork.Ethereum:
        try {
          EthereumAddress.fromHex(val).hex;
        } catch (e) {
          return false;
        }
        break;
      case TokenNetwork.BinanceSmartChain:
        try {
          EthereumAddress.fromHex(val).hex;
        } catch (e) {
          return false;
        }
        break;
      case TokenNetwork.Solana:
        return sol.isValidAddress(val);
    }
    return true;
  }

  void addContact() {
    var abm = locator<AddressBookModel>();
    if (mode == 1) {
      var contact = AddressBookContactEntity()
        ..addresses = [
          AddressBookAddressEntity()
            ..address = controllerAddress.text
            ..description = controllerNote.text
            ..network = network!.network
        ]
        ..name = controllerName.text
        ..id = '${DateTime.now().toString().hashCode}';
      abm.contacts.add(contact);
    } else {
      var contact =
          abm.contacts.firstWhere((element) => element.id == contactId);
      contact.addresses.add(AddressBookAddressEntity()
        ..address = controllerAddress.text
        ..description = controllerNote.text
        ..network = network!.network);
    }
    abm.saveAddressBook();
    abm.setState();
  }
}
