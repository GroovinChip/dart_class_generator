import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class CodeView extends StatefulWidget {
  final String data;
  final double fontSize;
  final bool edit;
  final String ext;
  final ValueChanged<String> onChanged;
  final bool showLineNumbers;

  const CodeView({
    Key key,
    @required this.data,
    this.onChanged,
    this.edit = true,
    this.fontSize = 16.0,
    @required this.ext,
    this.showLineNumbers,
  }) : super(key: key);
  @override
  _CodeViewState createState() => _CodeViewState();
}
class _CodeViewState extends State<CodeView> {
  final _controller = CodeEditingController();
  @override
  void initState() {
    _controller.text = widget.data;
    _controller.addListener(_onChanged);
    super.initState();
  }
  void _onChanged() {
    if (widget.onChanged != null) {
      widget.onChanged(_controller.text);
    }
  }
  @override
  void didUpdateWidget(CodeView oldWidget) {
    if (oldWidget.data != widget.data) {
      if (widget.data != _controller.text) {
        _controller.text = widget.data;
      }
    }
    super.didUpdateWidget(oldWidget);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Syntax _syntax = Syntax.DART;
    if (widget.ext != null) {
      if (widget.ext == 'kt') {
        _syntax = Syntax.KOTLIN;
      }
      if (widget.ext == 'dart') {
        _syntax = Syntax.DART;
      }
      if (widget.ext == 'swift') {
        _syntax = Syntax.SWIFT;
      }
      if (widget.ext == 'js' || widget.ext == 'ts' || widget.ext == 'jsx') {
        _syntax = Syntax.JAVASCRIPT;
      }
      if (widget.ext == 'java') {
        _syntax = Syntax.JAVA;
      }
    }
    final _theme = !isDark ? SyntaxTheme.standard() : SyntaxTheme.dracula();
    return SyntaxView(
      code: widget.data,
      syntax: _syntax,
      syntaxTheme: _theme,
      withZoom: true,
      withLinesCount: widget.showLineNumbers,
      fontSize: widget.fontSize,
    );
  }
}
