import 'package:flutter/foundation.dart';
import 'package:voola/shared.dart';

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  void setState([ViewState? viewState]) {
    _state = viewState ?? _state;
    try {
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
