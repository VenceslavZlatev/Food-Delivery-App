import 'package:flutter/widgets.dart';

class TotalAmount extends ChangeNotifier {
  double _totalAmount = 0;

  double get tAmount => _totalAmount;

  displayTotatAmount(double number) async {
    _totalAmount = number;

    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
