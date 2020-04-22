import 'package:flutter/material.dart';

class ClearButton extends StatelessWidget {
  const ClearButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.clear),
      tooltip: 'Clear',
      onPressed: onPressed,
    );
  }
}
