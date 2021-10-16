import 'package:flutter/material.dart';
import 'package:pulse_india/app_data.dart';
import 'package:pulse_india/components/responsive_ui.dart';
import 'package:pulse_india/handlers/database_handler.dart';
import 'package:pulse_india/models/user.dart';
import 'package:pulse_india/pages/attendance_report_page.dart';
import 'package:pulse_india/pages/select_date_page.dart';
import 'package:pulse_india/pages/upload_client_location.dart';
import 'package:pulse_india/pages/home_page.dart';
import 'package:pulse_india/pages/mark_attendance_page.dart';
import 'package:pulse_india/select_service_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';

class WelcomePage extends StatefulWidget {
  final SharedPreferences preferences;

  const WelcomePage({this.preferences});
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _welcomePageGlobalKey =
      new GlobalKey<ScaffoldState>();
  double _width, _pixelRatio, bottom1;
  AnimationController animationController;
  Animation<double> animation;
  @override
  void initState() {
    super.initState();
    Duration threeSeconds = Duration(seconds: 3);
    Future.delayed(threeSeconds, () {
      checkCurrentLogin(context);
    });
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation = new CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
      reverseCurve: Curves.elasticOut,
    );

    animation.addListener(() => this.setState(() {}));
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    bottom1 = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        key: _welcomePageGlobalKey,
        backgroundColor: Colors.white,
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: new AssetImage("assets/images/app_bg.jpg"),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                width: animation.value * 200,
                height: animation.value * 200,
              ),
              /*  Text(
                // "Spices & Grain Processing L.L.C.",
                AppTranslations.of(context).text("key_slogan"),
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Colors.green[600],
                    fontWeight: FontWeight.bold,
                    fontSize: _large ? 18 : (_medium ? 18 : 16)),
              ),*/
            ],
          ),
        ));
  }

  Future<void> checkCurrentLogin(BuildContext context) async {
    try {
      User user = await DBHandler().getLoggedInUser();
      //User user = AppData.current.user;
      if (user != null) {
        appData.user = user;
        appData.user.RoleNo = 2;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LoginPage(),

          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoginPage(),
          ),
        );
      }
    } catch (e) {}
  }
}
