import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:pulse_india/app_data.dart';
import 'package:pulse_india/constants/http_status_codes.dart';
import 'package:pulse_india/constants/internet_connection.dart';
import 'package:pulse_india/models/live_server_urls.dart';
import 'package:pulse_india/models/user.dart';

import '../app_data.dart';
import '../constants/project_settings.dart';

class NetworkHandler {
  static Uri getUri(String url, Map<String, dynamic> params) {
    try {
      params.addAll({
        UserFieldNames.UserNo:
            appData.user != null ? appData.user.UserNo.toString() : '',
       /* UserFieldNames.ClientId:
            appData.user == null ? "" : appData.user.ClientId.toString(),
        UserFieldNames.Brcode:
            appData.user == null ? "" : appData.user.Brcode.toString(),*/
        UserFieldNames.UserID:
            appData.user == null ? "" : appData.user.UserID.toString()
      });
      Uri uri = Uri.parse(url);

      return uri.replace(queryParameters: params);
    } catch (e) {
      return null;
    }
  }

  static Map<String, String> getHeader() {
    return {
      "CheckSum": ProjectSettings.AppKey,
    };
  }
  static Map<String, String> postHeader() {
    return {
    "Accept": "application/json",
    "content-type": "application/json",
      "CheckSum": ProjectSettings.AppKey,
    };
  }
  static Future<String> checkInternetConnection() async {
    String status;
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a mobile network.
        status = InternetConnection.CONNECTED;
      } else {
        // I am connected to no network.
        status = InternetConnection.NOT_CONNECTED;
      }
    } catch (e) {
      status = InternetConnection.NOT_CONNECTED;
      status = 'Exception: ' + e.toString();
    }
    return status;
  }
  static Future<String> getServerWorkingUrl() async {
    String connectionStatus = await NetworkHandler.checkInternetConnection();
    if (connectionStatus == InternetConnection.CONNECTED) {
      //Uncomment following to test local api
      return ProjectSettings.LocalApiUrl;

    } else {
      return "key_check_internet";
    }
  }

}
