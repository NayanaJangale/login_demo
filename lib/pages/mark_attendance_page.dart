import 'dart:async';
import 'dart:convert';
import 'package:geocoder/geocoder.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:pulse_india/app_data.dart';
import 'package:pulse_india/components/custom_cupertino_action.dart';
import 'package:pulse_india/components/custom_cupertino_action_message.dart';
import 'package:pulse_india/components/custom_gradient_button.dart';
import 'package:pulse_india/components/custom_progress_handler.dart';
import 'package:pulse_india/components/custom_take_picture.dart';
import 'package:pulse_india/components/flushbar_message.dart';
import 'package:pulse_india/constants/http_request_methods.dart';
import 'package:pulse_india/constants/http_status_codes.dart';
import 'package:pulse_india/constants/message_types.dart';
import 'package:pulse_india/constants/project_settings.dart';
import 'package:pulse_india/handlers/network_handler.dart';
import 'package:pulse_india/localization/app_translations.dart';
import 'package:pulse_india/models/attendance.dart';
import 'package:pulse_india/models/department.dart';
import 'package:pulse_india/models/user.dart';


class MarkAttendancePage extends StatefulWidget {
  @override
  _MarkAttendancePageState createState() => _MarkAttendancePageState();
}

class _MarkAttendancePageState extends State<MarkAttendancePage> {
  bool isLoading, islocLoading;
  String loadingText, entryType, latitude = "", longitude = "",altitude="",imagePath, address="";
  String selectedItem = "InTime", selectedReportType="Details";
  List<String> attendanceType = ['InTime', 'OutTime'];
  List<String> reportType = [
    'Details',
    'Summary',
  ];
  GlobalKey<ScaffoldState> _AttendancePageGlobalKey;
  List<String> menus = ['Camera'];
  File imgFile;
  List cameras;
  dynamic firstCamera;
  List<Department> departments = [];
  String selectedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
  Department selectedDepartment;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _AttendancePageGlobalKey = GlobalKey<ScaffoldState>();
    this.loadingText = 'Searching Location . . .';
    this.isLoading = true;
    this.islocLoading = true;
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      firstCamera = cameras[1];
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
      isLoading: this.isLoading || this.islocLoading,
      loadingText: this.loadingText,
      child: Scaffold(
          key: _AttendancePageGlobalKey,
          appBar:AppBar(
            title: Text(AppTranslations.of(context).text("key_mark_attendance")),
          ),
          body:Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if(departments==null){
                        FlushbarMessage.show(
                          context,
                          AppTranslations.of(context).text("key_add_department_not_available"),
                          MessageTypes.WARNING,
                        );
                      }else{
                        showClientDepartments();
                      }
                    },
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
                              child:  Text(
                                selectedDepartment!=null ? selectedDepartment.DepEName : AppTranslations.of(context).text("key_select_department"),
                                style:Theme.of(context).textTheme.bodyText2.copyWith(
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
                  SizedBox(
                    height: 10.0,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      showAttendanceType();
                    },
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
                              child:  Text(
                                selectedItem,
                                style:Theme.of(context).textTheme.bodyText2.copyWith(
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
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: imgFile == null
                              ? Container(
                            color: Colors.lightGreen[50],
                            child: Center(
                              child: Text(
                                AppTranslations.of(context).text("key_attendance_selfie"),
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(
                                  color: Colors.grey[700],
                                  fontWeight:
                                  FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                              : Image.file(
                            imgFile,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                          top: 0.0,
                          bottom: 0.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: Divider(
                          height: 0.0,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: Container(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder:
                                (BuildContext context, int index) {
                              return ListTile(
                                leading: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[700],
                                ),
                                title: Text(
                                  menus[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CustomTakePicture(
                                            camera: firstCamera,
                                          ),
                                    ),
                                  ).then((res) {
                                    setState(() {
                                      imgFile = File(res);
                                    });
                                  });
                                },
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(
                                  0.0,
                                ),
                                child: Divider(
                                  height: 0.0,
                                ),
                              );
                            },
                            itemCount: menus.length,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 0.0,
                          bottom: 0.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: Divider(
                          height: 0.0,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  CustomGradientButton(
                      caption:
                      AppTranslations.of(context).text("key_mark_attendance"),
                      onPressed: () {
                        String valMsg = getValidationMessage();
                        if (valMsg != '') {
                          FlushbarMessage.show(
                            context,
                            valMsg,
                            MessageTypes.WARNING,
                          );
                        } else {
                          postAttendance();
                        }
                      }),
                ],
              ),
            ),
          )
      ),
    );
  }
  Future<void> postAttendancveSelfie(int locEntNo) async {
    String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
    if (connectionServerMsg != "key_check_internet") {
      Uri postUri = Uri.parse(
        connectionServerMsg +
            ProjectSettings.rootUrl +
            'Attendance/PostVisitSelfy',
      ).replace(
        queryParameters: {
          'LocEntNo': locEntNo.toString(),
          UserFieldNames.UserNo :appData.user == null  ?  "" :  appData.user.UserNo.toString(),
        },
      );

      final mimeTypeData =
      lookupMimeType(imgFile.path, headerBytes: [0xFF, 0xD8]).split('/');
      final imageUploadRequest =
      http.MultipartRequest(HttpRequestMethods.POST, postUri);
      final file = await http.MultipartFile.fromPath(
        'image',
        imgFile.path,
        contentType: MediaType(
          mimeTypeData[0],
          mimeTypeData[1],
        ),
      );

      imageUploadRequest.fields['ext'] = mimeTypeData[1];
      imageUploadRequest.files.add(file);
      imageUploadRequest.headers.addAll( NetworkHandler.getHeader());
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      var data = json.decode(response.body);
      if (response.statusCode == HttpStatusCodes.CREATED) {
        FlushbarMessage.show(
          context,
          data["Message"],
          MessageTypes.SUCCESS,
        );
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
  }
  _getLocation() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    debugPrint('location: ${position.latitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    latitude = position.latitude.toString();
    longitude = position.longitude.toString();
    altitude =  position.altitude.toString();
    address= first.addressLine;
    this.islocLoading = false;
    if (longitude == '' || longitude == null || latitude == '' || latitude == null){
      FlushbarMessage.show(
        context,
        AppTranslations.of(context).text("key_location_instruction"),
        MessageTypes.WARNING,
      );
    }else{
      fetchDepartment().then((result) {
        setState(() {
          this.departments = result;
          if (departments != null && departments.length != 0) {
            selectedDepartment = departments[0];
            //departments.insert(0, new Department(DepId:  0,DepAEName: "" , DepEName:  "Select Department"));
          }
        });
      });
    }

  }
  Future<void> postAttendance() async {
    try {
      setState(() {
        isLoading = true;
        loadingText = 'Saving . . .';
      });
      if (selectedItem == "InTime") {
        entryType = 'I';
      } else {
        entryType = 'O';
      }
      Attendance attendance = Attendance(
          AttendanceId: 0,
          UserNo: appData.user.UserNo,
          EntDate: DateTime.now(),
          EntType: entryType,
          DepId: selectedDepartment.DepId,
          Latitude: latitude,
          Longitude: longitude,
          Address: address ,
          IsNet: "Y",
          Selfie: null
      );

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
        };
        Uri SaveDeptLocationUri = NetworkHandler.getUri(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                AttendanceUrls.POST_ATTENDANCE,
            params);
        String jsonBody = json.encode(attendance);
        http.Response response = await http.post(
          SaveDeptLocationUri,
          headers: NetworkHandler.postHeader(),

          body: jsonBody,
          encoding: Encoding.getByName("utf-8"),
        );
        var data = json.decode(response.body);
        if (data["Status"] == HttpStatusCodes.CREATED) {
          if (imgFile != null) {
            await postAttendancveSelfie(data["Message"]);
          }else{
            FlushbarMessage.show(
              context,
              data["Message"],
              MessageTypes.SUCCESS,
            );
          }

          _clearData();
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
    }
    setState(() {
      isLoading = false;
      loadingText = 'Loading..';
    });
  }
  void showAttendanceType() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: CustomCupertinoActionMessage(
          message: AppTranslations.of(context).text("key_entry_type"),
        ),
        actions: List<Widget>.generate(
          attendanceType.length,
              (i) => CustomCupertinoActionSheetAction(
            actionText: attendanceType[i] == 'InTime' ? 'InTime' : 'OutTime',
            actionIndex: i,
            onActionPressed: () {
              setState(() {
                selectedItem =
                attendanceType[i] == 'InTime' ? 'InTime' : 'OutTime';
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
  String getValidationMessage() {

    if (selectedDepartment == '' || selectedDepartment == null)
      return AppTranslations.of(context).text("key_dept_instruction");

    if (longitude == '' || longitude == null)
      return  AppTranslations.of(context).text("key_location_instruction");

    if (latitude == '' || latitude == null)
      return  AppTranslations.of(context).text("key_location_instruction");

    if (this.imgFile == null) {
      return  AppTranslations.of(context).text("key_selfie_instruction");
    }
    return '';
  }
  Future<List<Department>> fetchDepartment() async {
    List<Department> dept;
    try {
      setState(() {
        isLoading = true;
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          "latitude":latitude,//"20.9972931",
            "longitude":longitude,//"75.5559695",
            "DepId" : appData.user.DepId.toString()
        };

        Uri fetchDepartmentUri = NetworkHandler.getUri(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                DepartmentUrls.GET_DEPT_FOR_OFFICE,
            params);

        http.Response response = await http.get(fetchDepartmentUri, headers: NetworkHandler.getHeader());
        var data = json.decode(response.body);
        if (data["Status"] == HttpStatusCodes.OK) {
          var parsedJson = data["Data"];
          setState(() {
            List responseData = parsedJson;
            dept =
                responseData.map((item) => Department.fromJson(item)).toList();
          });

        } else {
          FlushbarMessage.show(
            context,
            data["Message"],
            MessageTypes.ERROR,
          );
          dept = null;
        }
      } else {
        FlushbarMessage.show(
          context,
          AppTranslations.of(context).text("key_check_internet"),
          MessageTypes.WARNING,
        );

        dept = null;
      }
    } catch (e) {
      FlushbarMessage.show(
        context,
        AppTranslations.of(context).text("key_api_error"),
        MessageTypes.WARNING,
      );

      dept = null;
    }
    setState(() {
      isLoading = false;
    });
    return dept;
  }

  void _clearData() {
    setState(() {
      imgFile = null;
    });
  }
  void showClientDepartments() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: CustomCupertinoActionMessage(
          message:AppTranslations.of(context).text("key_current_department"),
        ),
        actions: List<Widget>.generate(
          departments.length,
              (i) => CustomCupertinoActionSheetAction(
            actionText: departments[i].DepEName,
            actionIndex: i,
            onActionPressed: () {
              setState(() {
                selectedDepartment = departments[i];
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
  void showReportType() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: CustomCupertinoActionMessage(
          message: "Report Type",
        ),
        actions: List<Widget>.generate(
          reportType.length,
              (i) => CustomCupertinoActionSheetAction(
            actionText: reportType[i],
            actionIndex: i,
            onActionPressed: () {
              setState(() {
                selectedReportType = reportType[i];
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

}
