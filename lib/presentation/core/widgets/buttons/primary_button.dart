import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String textButton;
  final VoidCallback onPressed;
  final bool roundedShape;
  final bool enabled;

  PrimaryButton({
    Key key,
    @required this.textButton,
    @required this.onPressed,
    this.enabled = true,
    this.roundedShape = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ButtonStyle(
        shape: roundedShape
            ? MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              )
            : null,
      ),
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: Text(
          textButton,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
