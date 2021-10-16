import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pulse_india/input_components/custom_app_drawer.dart';
import 'package:pulse_india/pages/file_process_page.dart';

import '../app_data.dart';
import '../components/custom_progress_handler.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  String loadingText = 'Loading..';
  final GlobalKey<ScaffoldState> _scaffoldHomeKey =
      new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.isLoading = false;
    this.loadingText = 'Loading . . .';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomProgressHandler(
      isLoading: isLoading,
      loadingText: loadingText,
      child: Scaffold(
        appBar: AppBar(
          title: Text(appData.service),
        ),
        drawer: AppDrawer(),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                shadowColor: Colors.grey.withOpacity(0.01), // added
                type: MaterialType.card,
                elevation: 10,
                borderRadius: new BorderRadius.circular(10.0),
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                'Processed Files',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: Colors.grey),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  ProgressVertical(
                                    value: 50,
                                    date: "Mon",
                                    isShowDate: true,
                                  ),
                                  ProgressVertical(
                                    value: 50,
                                    date: "Tue",
                                    isShowDate: true,
                                  ),
                                  ProgressVertical(
                                    value: 45,
                                    date: "Wed",
                                    isShowDate: true,
                                  ),
                                  ProgressVertical(
                                    value: 30,
                                    date: "Thu",
                                    isShowDate: true,
                                  ),
                                  ProgressVertical(
                                    value: 50,
                                    date: "Fri",
                                    isShowDate: true,
                                  ),
                                  ProgressVertical(
                                    value: 20,
                                    date: "Sat",
                                    isShowDate: true,
                                  ),
                                  ProgressVertical(
                                    value: 45,
                                    date: "Sun",
                                    isShowDate: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ), // added
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Upcoming Files',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ),
              //Show pending files here
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: List.generate(10, (index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FileProcessPage(),
                              ),
                            );
                          },
                          title: Text(
                            'SIV 1100 $index / 2021',
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Colors.grey,
                                    ),
                          ),
                          subtitle: Text(
                            '${index + 1}/03/21',
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.grey[300],
                            size: 20,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressVertical extends StatelessWidget {
  final int value;
  final String date;
  final bool isShowDate;

  ProgressVertical(
      {Key key,
      @required this.value,
      @required this.date,
      @required this.isShowDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //   margin: EdgeInsets.only(right: 7),
      width: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Container(
              width: 10,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                shape: BoxShape.rectangle,
                color: Colors.green.withOpacity(0.3),
              ),
              child: new LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          shape: BoxShape.rectangle,
                          color: Colors.green,
                        ),
                        height: constraints.maxHeight * (value / 100),
                        width: constraints.maxWidth,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          SizedBox(height: 10),
          Text(
            (isShowDate) ? date : "",
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}

enum ClipType { bottom, semiCircle, halfCircle, multiple }

class MyCustomClipper extends CustomClipper<Path> {
  ClipType clipType;

  MyCustomClipper({this.clipType});

  @override
  getClip(Size size) {
    var path = new Path();
    if (clipType == ClipType.bottom) {
      createBottom(size, path);
    } else if (clipType == ClipType.semiCircle) {
      createSemiCirle(size, path);
    } else if (clipType == ClipType.halfCircle) {
      createHalfCircle(size, path);
    } else if (clipType == ClipType.multiple) {
      createMultiple(size, path);
    }
    path.close();
    return path;
  }

  createSemiCirle(Size size, Path path) {
    path.lineTo(size.width / 1.40, 0);

    var firstControlPoint = new Offset(size.width / 1.30, size.height / 2.5);
    var firstEndPoint = new Offset(size.width / 1.85, size.height / 1.85);

    var secondControlPoint = new Offset(size.width / 4, size.height / 1.45);
    var secondEndPoint = new Offset(0, size.height / 1.75);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(0, size.height / 1.75);
  }

  createBottom(Size size, Path path) {
    path.lineTo(0, size.height / 1.19);
    var secondControlPoint = new Offset((size.width / 2), size.height);
    var secondEndPoint = new Offset(size.width, size.height / 1.19);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
  }

  createHalfCircle(Size size, Path path) {
    path.lineTo(size.width / 2, 0);
    var firstControlPoint = new Offset(size.width / 1.10, size.height / 2);
    var firstEndPoint = new Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.lineTo(0, size.height);
  }

  createMultiple(Size size, Path path) {
    path.lineTo(0, size.height);

    var curXPos = 0.0;
    var curYPos = size.height;
    Random rnd = new Random();

    var increment = size.width / 40;
    while (curXPos < size.width) {
      curXPos += increment;
      curYPos = curYPos == size.height
          ? size.height - rnd.nextInt(50 - 0)
          : size.height;
      path.lineTo(curXPos, curYPos);
    }
    path.lineTo(size.width, 0);
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
