import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomProgressHandler extends StatefulWidget {
  final String loadingText;
  final Widget child;
  final bool isLoading;

  const CustomProgressHandler({
    Key key,
    this.loadingText,
    this.child,
    this.isLoading,
  }) : super(key: key);

  @override
  _CustomProgressHandlerState createState() => _CustomProgressHandlerState();
}

class _CustomProgressHandlerState extends State<CustomProgressHandler> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Stack(
        children: <Widget>[
          widget.child,
          new Opacity(
            child: new ModalBarrier(dismissible: false, color: Colors.grey),
            opacity: 0.5,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                //   color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              padding: EdgeInsets.all(8),
              /*EdgeInsets.only(
                top: 20.0,
                bottom: 20.0,
                left: 50.0,
                right: 50.0,
              ),*/
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Theme(
                      data: ThemeData(
                        cupertinoOverrideTheme: CupertinoThemeData(
                          brightness: Brightness.dark,
                        ),
                      ),
                      child: CupertinoActivityIndicator(
                        animating: true,
                        radius: 15.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      widget.loadingText,
                      style: Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          widget.child,
        ],
      );
    }
  }
}
