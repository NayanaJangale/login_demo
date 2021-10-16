import 'package:flutter/material.dart';

class ListFilterBar extends StatelessWidget {
  final Function onCloseButtonTap;
  final TextEditingController searchFieldController;

  ListFilterBar({
    this.onCloseButtonTap,
    this.searchFieldController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          topLeft: Radius.circular(20.0),
         // bottomRight: Radius.circular(3.0),
         // bottomLeft: Radius.circular(3.0),
        ),

      ),
      //color: Colors.blue[100],
      child: Padding(
        padding: const EdgeInsets.only(
          top: 15,
          left: 10.0,
          bottom: 10.0,
          right: 10.0,
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.search,
              color: Colors.blue[800],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                ),
                child: TextFormField(
                  autofocus: false,
                  controller: searchFieldController,
                  decoration: InputDecoration.collapsed(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none),
                    hintText:"Search Employee..",
                    hintStyle: Theme.of(context).textTheme.body2.copyWith(
                      color:  Colors.blue[800],
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.blue[800],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onCloseButtonTap,
              child: Icon(
                Icons.close,
                color:  Colors.blue[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
