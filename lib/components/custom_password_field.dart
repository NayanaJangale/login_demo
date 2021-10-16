import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  final String hint;
  final int maxlength;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  final Function validation;
  final Function onFieldSubmitted;
  final FocusNode focusNode;
  final double  borderRadius;
  final Color  borderColor;

  CustomPasswordField({
    this.hint,
    this.maxlength,
    this.textEditingController,
    this.keyboardType,
    this.icon,
    this.validation,
    this.focusNode,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.borderRadius ,
    this.borderColor
  });

  @override
  _CustomPasswordFieldState createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor??Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              widget.icon,
              color: Colors.grey,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: widget.borderColor ?? Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
          ),
          new Expanded(
            child: TextField(
              controller: widget.textEditingController,
              maxLength: widget.maxlength,
              focusNode: widget.focusNode,
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _visible = !_visible;
                    });
                  },
                  child: new Icon(
                    _visible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    //  color: Theme.of(context).primaryColor,
                    color: Colors.black45,
                  ),
                ),
                hintText: widget.hint,
                hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Colors.grey,
                ),
                labelStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Colors.grey,
                  //fontWeight: FontWeight.w600,
                ),
              ),
              obscureText: _visible,
            ),
          )
        ],
      ),
    );
  }
}
