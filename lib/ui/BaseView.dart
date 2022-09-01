import 'package:voola/shared.dart';

import 'package:provider/provider.dart';
import 'package:voola/locator.dart';

import 'BaseViewModel.dart';

class BaseView<T extends BaseViewModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget?) builder;
  final Function(T)? onModelReady;
  final T? model;
  BaseView({required this.builder, this.onModelReady, this.model});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  late T model;

  @override
  void initState() {
    model = widget.model ?? locator<T>();
    widget.onModelReady?.call(model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
        value: model,
        child: Consumer<T>(builder: (_, m, __) {
          try {
            return widget.builder(_, m, __);
          } catch (e, st) {
            print('$e,$st');
            return Directionality(
                textDirection: TextDirection.ltr,
                child: Text('Error'));
          }
        }));
  }
}
