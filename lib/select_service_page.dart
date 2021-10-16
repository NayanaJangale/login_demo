import 'package:flutter/material.dart';
import 'package:pulse_india/utils/clipper.dart';

import 'app_data.dart';
import 'components/responsive_ui.dart';
import 'constants/action_constants.dart';
import 'handlers/database_handler.dart';
import 'models/user.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';

class SelectServicePage extends StatefulWidget {
  @override
  _SelectServicePageState createState() => _SelectServicePageState();
}

class _SelectServicePageState extends State<SelectServicePage> {
  bool isLoading = false;
  String loadingText = 'Loading..';
  final GlobalKey<ScaffoldState> _scaffoldHomeKey =
      new GlobalKey<ScaffoldState>();

  List<String> options = [
    'Inward',
    'Outward',
    'Stock Manufacturing',
    'Stock Transferred',
    'Stock Packaging',
    'Bag Transfers',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.isLoading = false;
    this.loadingText = 'Loading . . .';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        overflow: Overflow.visible,
        fit: StackFit.loose,
        children: <Widget>[
          ClipPath(
            clipper: ClippingClass(),
            child: Container(
              width: double.infinity,
              height: size.height * 0.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).accentColor,
                    Theme.of(context).primaryColor
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: size.width * 0.05,
            top: size.height * 0.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Hi, Mehmud",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  "Manage your work",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: size.height * 0.05, right: 10),
              child: IconButton(
                onPressed: () {
                  showLogoutConfirmationDialog();
                },
                icon: Icon(
                  Icons.power_settings_new,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            left: size.width * 0.05,
            top: size.height * 0.15,
            right: size.width * 0.05,
            child: Container(
              alignment: Alignment.topCenter,
              height: size.height * 0.85,
              width: size.width,
              child: GridView.builder(
                itemCount: options.length,
                primary: false,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return new GestureDetector(
                    onTap: () {
                      setState(() {
                        appData.service = options[index];
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomePage(),
                        ),
                      );
                    },
                    child: _customCard(
                      icon: Icons.add_circle_outline_sharp,
                      item: options[index],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _customCard({IconData icon, String item}) {
    Size size = MediaQuery.of(context).size;
    double _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    bool large = ResponsiveWidget.isScreenLarge(size.width, _pixelRatio);
    bool medium = ResponsiveWidget.isScreenMedium(size.width, _pixelRatio);
    return SizedBox(
      height: size.height * 0.2,
      width: size.width * 0.4,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              getIcon(item),
              color: Theme.of(context).primaryColorLight,
              size: large
                  ? 40
                  : medium
                      ? 30
                      : 20,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  item,
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData getIcon(String service) {
    switch (service) {
      case 'Inward':
        return Icons.arrow_circle_down_outlined;
        break;
      case 'Outward':
        return Icons.outbond_outlined;
        break;
      case 'Bag Transfers':
        return Icons.shopping_bag_outlined;
        break;
      case 'Stock Packaging':
        return Icons.backpack_outlined;
        break;
      case 'Stock Transferred':
        return Icons.filter_tilt_shift_sharp;
        break;
      case 'Stock Manufacturing':
        return Icons.precision_manufacturing_sharp;
        break;
    }
  }

  Widget _actionsPopup() => PopupMenuButton(
        padding: EdgeInsets.only(right: 10),
        onSelected: (value) {
          if (value == ActionOptions.LOG_OUT) {
            showLogoutConfirmationDialog();
          } else if (value == ActionOptions.SETTINGS) {
            /* Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SettingsPage(),
          ),
        );*/
          }
        },
        icon: Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
        itemBuilder: (context) {
          var list_new = List.generate(
            actionOptions.length,
            (int index) {
              return PopupMenuItem(
                child: Text(
                  actionOptions[index],
                  style: Theme.of(context).textTheme.body2.copyWith(
                        color: Colors.black87,
                      ),
                ),
                value: actionOptions[index],
              );
            },
          );
          return list_new;
        },
      );

  showLogoutConfirmationDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              //height: MediaQuery.of(context).size.height * 3 / 10,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Do you want to Log Out..?',
                      style: Theme.of(context).textTheme.title.copyWith(
                            color: Colors.black87,
                          ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "No",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green[500],
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            DBHandler().logout(appData.user).then((value) {
                              User user = value;
                              if (user != null) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              }
                            });
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.red[500],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
