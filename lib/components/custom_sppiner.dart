import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSpinner extends StatelessWidget {
  final String selectedText;
  final Function onActionTapped;
  final bool visibilityStatus ;

  CustomSpinner({
    this.selectedText,
    @required this.onActionTapped,
    @required this.visibilityStatus
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibilityStatus ?? true,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onActionTapped,
        child: Card(
          margin: EdgeInsets.zero,
          color: Colors.grey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                topRight: Radius.circular(30)),
            // side: BorderSide(width: 5, color: Colors.green)
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    selectedText,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


