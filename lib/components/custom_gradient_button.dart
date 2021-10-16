import 'package:flutter/material.dart';
import 'package:pulse_india/themes/button_styles.dart';

class CustomGradientButton extends StatelessWidget {
  final String caption;
  final Function onPressed;

  const CustomGradientButton({
    this.caption,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: ElevatedButton(
        onPressed: this.onPressed,
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColorLight,
          onPrimary: Colors.white,
          onSurface: Colors.grey,
        ),
        child: Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                caption,
                style: ButtonStyles.getLightButtonTextStyle(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
