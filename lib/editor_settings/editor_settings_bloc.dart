import 'package:rxdart/rxdart.dart';

/// this is runtime only for now
class EditorSettingsBloc {
  final _lineNumbersController = BehaviorSubject<bool>.seeded(true);
  final _codeFontSizeController = BehaviorSubject<double>.seeded(24);
  final _codeEditingController = BehaviorSubject<bool>.seeded(false);

  Sink<bool> get lineNumbersOn => _lineNumbersController.sink;
  Sink<double> get fontSize => _codeFontSizeController.sink;
  Sink<bool> get codeEditingOn => _codeEditingController.sink;

  ValueStream<bool> get lineNumbersStream => _lineNumbersController.stream;
  ValueStream<double> get codeFontSizeStream => _codeFontSizeController.stream;
  ValueStream<bool> get codeEditingStream => _codeEditingController.stream;

  void close() {
    _lineNumbersController.close();
    _codeFontSizeController.close();
    _codeEditingController.close();
  }
}
