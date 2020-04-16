import 'package:rxdart/rxdart.dart';

/// this is runtime only for now
class SettingsBloc {
  final _lineNumbersController = BehaviorSubject<bool>.seeded(true);
  final _codeFontSizeController = BehaviorSubject<double>.seeded(24);

  Sink<bool> get lineNumbersOn => _lineNumbersController.sink;
  Sink<double> get fontSize => _codeFontSizeController.sink;

  ValueStream<bool> get lineNumbersStream => _lineNumbersController.stream;
  ValueStream<double> get codeFontSizeStream => _codeFontSizeController.stream;

  void close () {
    _lineNumbersController.close();
    _codeFontSizeController.close();
  }
}
