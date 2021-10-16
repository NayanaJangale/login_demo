import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pulse_india/app_data.dart';
import 'package:pulse_india/models/menu.dart';

import '../components/flushbar_message.dart';
import '../constants/http_status_codes.dart';
import '../constants/message_types.dart';
import '../constants/project_settings.dart';
import '../handlers/network_handler.dart';
import '../localization/app_translations.dart';
import '../pages/home_page.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  List<Menu> menus = [];
  bool isLoading;
  bool isLocation;
  String loadingText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isLoading = false;
    isLocation = false;
    loadingText = 'Loading Menus...';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0.0,
      child: Column(
        children: <Widget>[
          _createHeader(context),
          Divider(
            color: Colors.grey,
          ),
          isLoading
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CupertinoActivityIndicator(),
                )
              : Expanded(
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemCount: menus.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ExpansionTile(
                        title: Text(
                          getMenuName(menus[index].Name),
                        ),
                        children: menus[index].child.map((e) {
                          return _createDrawerItem(
                            context: context,
                            text: getMenuName(e.action_desc),
                            asset: getMenuImage(e.action_desc),
                            onTap: getMenuTap(e.action_desc),
                          );
                        }).toList(),
                      );
                      /*return _createDrawerItem(
                        context: context,
                        text: menus[index].Name,
                        asset: getMenuImage(menus[index].Name),
                        onTap: getMenuTap(index),
                      );*/
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      /* decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColorDark,
            Theme.of(context).primaryColor,
          ],
        ),
      ),*/
      child: Stack(
        children: <Widget>[
          Positioned(
            left: MediaQuery.of(context).size.width * 0.02,
            top: MediaQuery.of(context).size.height * 0.03,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1,
                ),
                // color: Colors.white,
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/logo.png",
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.02,
            bottom: MediaQuery.of(context).size.height * 0.03,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mehmud Aziz Abdul Kazi",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.02,
            bottom: MediaQuery.of(context).size.height * 0.001,
            child: Text(
              "Auditor",
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Theme.of(context).primaryColorLight,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData asset,
      String text,
      GestureTapCallback onTap,
      BuildContext context}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          /*Image.asset(
            asset,
            width: 30,
            height: 30,
          ),*/
          Icon(
            asset,
            size: 25,
            color: Theme.of(context).accentColor,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.body2.copyWith(
                    color: Colors.black87,
                  ),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Function getMenuTap(String menuName) {
    switch (menuName) {
      default:
        return () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(),
            ),
          );
        };
        break;
    }
  }

  String getMenuName(String menuName) {
    switch (menuName) {
      default:
        return 'Menu';
        break;
    }
  }

  IconData getMenuImage(String menuName) {
    switch (menuName) {
      default:
        return Icons.description;
        break;
    }
  }

  Future<List<Menu>> fetchMenus() async {
    List<Menu> allMenus;
    setState(() {
      isLoading = true;
    });

    try {
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        if (connectionServerMsg != "key_no_server" &&
            connectionServerMsg != '') {
          Map<String, dynamic> params = {
            "userID": appData.user.UserNo.toString(),
          };

          Uri fetchMenusUri = NetworkHandler.getUri(
            connectionServerMsg + ProjectSettings.rootUrl + MenuUrls.GET_MENUS,
            //ProjectSettings.apiUrl + MenuUrls.GET_MENUS,
            params,
          );

          print(fetchMenusUri);

          http.Response response = await http.get(
            fetchMenusUri,
            headers: NetworkHandler.getHeader(),
          );

          var data = json.decode(response.body);

          if (response.statusCode == HttpStatusCodes.OK) {
            if (data["Status"] != HttpStatusCodes.OK) {
              FlushbarMessage.show(
                this.context,
                data["Message"],
                MessageTypes.ERROR,
              );
              //allMenus = await DBHandler().getMenuList();
            } else {
              var parsedJson = data["Data"];
              setState(() {
                List responseData = parsedJson;
                allMenus =
                    responseData.map((item) => Menu.fromMap(item)).toList();
              });

              //  await DBHandler().deleteMenus();
              //  await DBHandler().saveMenus(allMenus);
            }
          } else {
            // allMenus = await LocalDbHandler().getMenuList();

            FlushbarMessage.show(
              this.context,
              'Invalid response received (${response.statusCode})',
              MessageTypes.ERROR,
            );
          }
        } else {
          //    allMenus = await DBHandler().getMenuList();

          FlushbarMessage.show(
            this.context,
            AppTranslations.of(context).text("key_no_server"),
            MessageTypes.WARNING,
          );
        }
      } else {
        // allMenus = await DBHandler().getMenuList();
      }
    } catch (e) {
      print(e);
      FlushbarMessage.show(
        this.context,
        AppTranslations.of(context).text("key_api_error"),
        MessageTypes.WARNING,
      );
      //  allMenus = await DBHandler().getMenuList();
    }

    setState(() {
      isLoading = false;
    });

    return allMenus;
  }
}
