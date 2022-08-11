import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/views/start/StartScreen.dart';
import 'package:voola/ui/views/wallet/WalletMainScreen.dart';
import 'package:voola/ui/views/wallet/WalletMainScreenModel.dart';

class AccountsSettingsScreen extends StatelessWidget {
  AccountsSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AccountsSettingsModel>(
      onModelReady: (model) {},
      builder: (context, model, child) {
        return Scaffold(
            appBar: CAppBar(
              elevation: 0,
              title: Text('Edit / add'),
            ),
            body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ReorderableListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        for (int index = 0;
                            index < model.accManager.allAccounts.length;
                            index++)
                          Container(
                            key: Key('$index'),
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.generalShapesBg,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                AppIcons.reorder(24, AppColors.text),
                                SizedBox(width: 10),
                                Text(
                                    '${model.accManager.allAccounts[index].accountAlias}'),
                                Spacer(),
                                PopupMenuButton<int>(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.more_vert_outlined),
                                    onSelected: (val) {
                                      model.onSelectedPopupMenu(
                                          val, index, context);
                                    },
                                    itemBuilder: (context) => [
                                          PopupMenuItem<int>(
                                            value: 1,
                                            child: Text(S.of(context).rename,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1),
                                          ),
                                          if (model.accManager.allAccounts
                                                  .length >
                                              1)
                                            PopupMenuItem<int>(
                                              value: 2,
                                              child: Text(S.of(context).logOut,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1),
                                            ),
                                        ])
                              ],
                            ),
                          ),
                      ],
                      onReorder: (int oldIndex, int newIndex) {
                        if (oldIndex < newIndex) newIndex -= 1;
                        final acc =
                            model.accManager.allAccounts.removeAt(oldIndex);
                        model.accManager
                          ..allAccounts.insert(newIndex, acc)
                          ..saveAccounts();
                        model.setState();
                      },
                    ),
                    SizedBox(height: 10),
                    Button(
                        value: 'Add wallet +',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => StartScreen(addWallet: true)));
                        })
                  ],
                )));
      },
    );
  }
}

class AccountsSettingsModel extends BaseViewModel {
  final accManager = locator<AccountManager>();

  onSelectedPopupMenu(int value, int index, BuildContext context) {
    if (value == 1) {
      newAlias(context, index);
    } else if (value == 2) {
      deleteAccount(context, index);
    }
  }

  Future<void> newAlias(BuildContext context, int index) async {
    var aliasController = TextEditingController();
    var newAlias = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        //backgroundColor: locator<AppGlobalModel>().isDarkTheme(context) ? Colors.grey[850] : Colors.white,
        titleTextStyle: Theme.of(context).dialogTheme.titleTextStyle,
        contentTextStyle: Theme.of(context).dialogTheme.contentTextStyle,
        title: Column(
          children: [
            TextFormField(
              decoration: generalTextFieldDecor(context,
                  hintText: S.of(context).newAccountName),
              controller: aliasController,
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value?.isEmpty == true) return S.of(context).cantBeEmpty;
              },
            ),
          ],
        ),
        actions: <Widget>[
          SimpleDialogOption(
            child: Text(
              S.of(context).cancel,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: AppColors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          SimpleDialogOption(
            child: Text(
              S.of(context).confirm,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: AppColors.active),
            ),
            onPressed: () {
              if (aliasController.text.isNotEmpty) {
                Navigator.of(context).pop(aliasController.text);
              }
            },
          )
        ],
      ),
    );
    if (newAlias != null) {
      accManager.allAccounts[index].accountAlias = newAlias;
      setState();

      //locator<MainScreenModel>().setStateAllModels();
      accManager.saveAccounts();
    }
    aliasController.dispose();
  }

  deleteAccount(BuildContext context, int index) async {
    var confirmed = (await showConfirmationDialog(S.of(context).logOutQuestion,
            S.of(context).checkSavedMnemonicSingle))
        .confirmed;
    if (confirmed) {
      accManager.allAccounts.removeAt(index);
      setState();
      accManager.saveAccounts();
    }
  }
}
