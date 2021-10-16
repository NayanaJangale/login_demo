import 'package:flutter/material.dart';

class NotFoundWidget extends StatefulWidget {
  final String widgetType;
  final Function onClick;

  NotFoundWidget({
    this.widgetType,
    this.onClick,
  });

  @override
  _NotFoundWidgetState createState() => _NotFoundWidgetState();
}

class _NotFoundWidgetState extends State<NotFoundWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            widget.widgetType == 'D'
                ? 'assets/images/notfound.png'
                : 'assets/images/nonet.png',
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.4,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'NOT FOUND',
                style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.widgetType == 'D'
                    ? 'Your requested data is not found'
                    : 'Network not found',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Colors.black54,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: widget.onClick,
                child: Text('Retry'),
                textColor: Theme.of(context).primaryColorDark,
              )
            ],
          ),
          /*  Expanded(child: MyAnimatedWaveCurves()),*/
        ],
      ),
    );
  }
}
