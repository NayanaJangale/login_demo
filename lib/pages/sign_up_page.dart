import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:device_info/device_info.dart';
import 'package:pulse_india/app_data.dart';
import 'package:pulse_india/constants/http_status_codes.dart';
import 'package:pulse_india/handlers/database_handler.dart';
import 'package:pulse_india/localization/app_translations.dart';
import 'package:pulse_india/models/user.dart';
import 'package:pulse_india/select_service_page.dart';import '../components/custom_gradient_button.dart';
import '../components/custom_password_field.dart';
import '../components/custom_progress_handler.dart';
import '../components/custom_text_field.dart';
import '../components/flushbar_message.dart';
import '../constants/message_types.dart';
import '../constants/project_settings.dart';
import '../handlers/network_handler.dart';

class SignUpPage extends StatefulWidget {

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading;
  String _loadingText;
  String deviceId = "";
  String smsAutoId;
  DBHandler _dbHandler;
  TextEditingController uniqueIDController;
  TextEditingController confirmPasswordController;
  TextEditingController passwordController;
  TextEditingController userIDController;
  FocusNode _passwordFocusNode;
  FocusNode _confirmPasswordFocusNode;
  FocusNode _userIDFocusNode;
  final GlobalKey<ScaffoldState> _signupScaffoldKey =
      new GlobalKey<ScaffoldState>();
  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    _getId().then((res) {
      setState(() {
        deviceId = res;
      });
    });
    _dbHandler = DBHandler();
    _isLoading = false;
    _loadingText = 'Loading . . .';
    uniqueIDController = TextEditingController();
    confirmPasswordController = TextEditingController();
    passwordController = TextEditingController();
    userIDController = TextEditingController();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
    _userIDFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomProgressHandler(
        isLoading: this._isLoading,
        loadingText: this._loadingText,
        child: Scaffold(
          key: _signupScaffoldKey,
          resizeToAvoidBottomInset: true,
          body: Container(
            height: double.infinity,
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: new AssetImage("assets/images/app_bg.jpg"),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.only(left: 14,right: 14),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Container(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.text,
                      autofoucus: false,
                      textEditingController: userIDController,
                      focusNode: _userIDFocusNode,
                      onFieldSubmitted: (value) {
                        this._userIDFocusNode.unfocus();
                        FocusScope.of(context)
                            .requestFocus(this._passwordFocusNode);
                      },
                      icon: Icons.person_outline_outlined,
                      hint: AppTranslations.of(context).text("key_userId"),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    CustomPasswordField(
                      keyboardType: TextInputType.text,
                      textEditingController: passwordController,
                      obscureText: true,
                      icon: Icons.lock_outline_sharp,
                      hint: AppTranslations.of(context).text("key_password"),
                      focusNode: _passwordFocusNode,
                      onFieldSubmitted: (value) {
                        this._passwordFocusNode.unfocus();
                        FocusScope.of(context)
                            .requestFocus(this._confirmPasswordFocusNode);
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    CustomPasswordField(
                      keyboardType: TextInputType.text,
                      textEditingController: confirmPasswordController,
                      obscureText: true,
                      icon: Icons.lock_outline_sharp,
                      hint: AppTranslations.of(context)
                          .text("key_confirm_password"),
                      focusNode: _confirmPasswordFocusNode,
                      onFieldSubmitted: (value) {
                        this._confirmPasswordFocusNode.unfocus();
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.text,
                      autofoucus: false,
                      textEditingController: uniqueIDController,
                      icon: Icons.phone_android,
                      enable: false,
                      hint: deviceId,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    CustomGradientButton(
                        caption:
                            AppTranslations.of(context).text("key_sign_up"),
                        onPressed: () {
                          String valMsg = getValidationMessage();
                          if (valMsg != '') {
                            FlushbarMessage.show(
                              context,
                              valMsg,
                              MessageTypes.WARNING,
                            );
                          } else {
                            UpdateUniqueID();
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        ));
  }


  Future<void> UpdateUniqueID() async {
    try {
      setState(() {
        _isLoading = true;
        _loadingText = 'Processing . .';

      });
      //TODO: Call change password Api here

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri postChangePasswordUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              UserUrls.POST_UNIQUE_ID,
          {
            "UserId": userIDController.text.toString() ,
            "deviceId": deviceId,
            "user_pwd" : confirmPasswordController.text.toString()
          },
        );

        http.Response response = await http.post(postChangePasswordUri, headers: NetworkHandler.getHeader());
        setState(() {
          _isLoading = false;
          _loadingText = '';
        });
        var data = json.decode(response.body);
        if (data["Status"] == HttpStatusCodes.CREATED) {
          User user = User.fromJson(
            data["Data"],
          );
          if (user == null) {
            FlushbarMessage.show(
              context,
              AppTranslations.of(context).text("key_invalid_User_id"),
              MessageTypes.ERROR,
            );
          } else {
            if (user.UserPass == passwordController.text) {
              //Save user to local db
              user = await _dbHandler.saveUser(user);
              if (user != null) {
                user = await _dbHandler.login(user);
                appData.user = user;
                FlushbarMessage.show(
                  context,
                  data["Message"],
                  MessageTypes.ERROR,
                );

                Future.delayed(Duration(seconds: 3)).then((val) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SelectServicePage(),
                      // builder: (_) => SubjectsPage(),
                    ),
                        (Route<dynamic> route) => false,
                  );
                });
              } else {
                FlushbarMessage.show(
                  context,
                  AppTranslations.of(context).text("key_invalid_local_login"),
                  MessageTypes.ERROR,
                );
              }
            } else {
              FlushbarMessage.show(
                context,
                AppTranslations.of(context).text("key_invalid_password"),
                MessageTypes.ERROR,
              );
            }
          }

        } else {
          FlushbarMessage.show(
            context,
            data["Message"],
            MessageTypes.ERROR,
          );

        }
      } else {
        FlushbarMessage.show(
          context,
          AppTranslations.of(context).text("key_check_internet"),
          MessageTypes.WARNING,
        );
      }
    } catch (e) {
      FlushbarMessage.show(
        context,
        AppTranslations.of(context).text("key_api_error"),
        MessageTypes.WARNING,
      );
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  String getValidationMessage() {
    if (userIDController.text.length == 0) {
      return AppTranslations.of(context).text("key_enter_user_id");
    }
    if (passwordController.text.length == 0 || confirmPasswordController.text.length==0){
      return  AppTranslations.of(context).text("key_password_should_be_mandatory");

    }
    Pattern pattern = r'^(?=.{6,}$)(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?\W).*$';
    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(passwordController.text))
      return AppTranslations.of(context).text("key_password_strength");


    if (passwordController.text != confirmPasswordController.text) {
      return AppTranslations.of(context).text("key_password_same");
    }

    if (deviceId == '' || deviceId == null)
      return AppTranslations.of(context).text("key_device_id_not_found");
    return '';
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}
