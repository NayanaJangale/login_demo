import 'package:flutter/material.dart';
import 'package:pulse_india/components/responsive_ui.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  bool enable;
  bool autofoucus;
  final int maxLength;
  final Function onFieldSubmitted;
  final FocusNode focusNode;
  final Function validation;
  final double borderRadius ;
  final Color borderColor;

  CustomTextField({
    this.hint,
    this.textEditingController,
    this.keyboardType,
    this.icon,
    this.autofoucus,
    this.validation,
    this.focusNode,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.enable,
    this.maxLength,
    this.borderRadius,
    this.borderColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(borderRadius) ?? 20,
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              icon,
              color: Colors.grey,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
          ),
          new Expanded(
            child: TextField(
              controller: textEditingController,
              maxLength: maxLength,
              focusNode: focusNode,
              autofocus: autofoucus,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.grey,
                      )),
            ),
          )
        ],
      ),
    );
  }
}
