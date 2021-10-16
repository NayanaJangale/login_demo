import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pulse_india/app_data.dart';
import 'package:pulse_india/components/custom_cupertino_action.dart';
import 'package:pulse_india/components/custom_cupertino_action_message.dart';
import 'package:pulse_india/components/custom_progress_handler.dart';
import 'package:pulse_india/components/flushbar_message.dart';
import 'package:pulse_india/components/list_filter_bar.dart';
import 'package:pulse_india/constants/http_status_codes.dart';
import 'package:pulse_india/constants/message_types.dart';
import 'package:pulse_india/constants/project_settings.dart';
import 'package:pulse_india/handlers/network_handler.dart';
import 'package:pulse_india/localization/app_translations.dart';
import 'package:pulse_india/models/department.dart';
import 'package:pulse_india/models/employee.dart';
import 'package:pulse_india/models/user.dart';
import 'package:pulse_india/pages/attendance_report_page.dart';

class SelectDatePage extends StatefulWidget {
  @override
  _SelectDatePageState createState() => _SelectDatePageState();
}

class _SelectDatePageState extends State<SelectDatePage> {
  bool isLoading;
  List<Department> departments = [];
  Department selectedDepartment;
  String loadingText,
      filter,
      selectedReportType = "Details",
      SelectedAttendanceStatus = "ALL",
      SelectedAttStatus;
  List<String> reportType = [
    'Details',
    'Summary',
  ];
  List<String> attendanceStatus = [
    'ALL',
    'Absent',
    'Present',
  ];
  List<User> _user = [];
  List<User> _filteredList = [];
  User selectedEmployee;
  final GlobalKey<ScaffoldState> _SelectDateKey =
      new GlobalKey<ScaffoldState>();
  TextEditingController filterController;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  double _addItemHeight = 400.0;
  Future<Null> _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
      if (endDate.isBefore(startDate)) {
        FlushbarMessage.show(
          context,
          "Date not valid For Report",
          MessageTypes.ERROR,
        );
        setState(() {
          startDate = DateTime.now();
        });
      }
    }
  }

  Future<Null> _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
      if (endDate.isBefore(startDate)) {
        FlushbarMessage.show(
          context,
          "Date not valid For Report",
          MessageTypes.ERROR,
        );

        setState(() {
          endDate = DateTime.now();
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.isLoading = false;
    this.loadingText = 'Loading . . .';

    filterController = new TextEditingController();
    filterController.addListener(() {
      setState(() {
        filter = filterController.text;
      });
    });
    if (appData.user.RoleNo == 1) {
      fetchDepartment().then((result) {
        setState(() {
          this.departments = result;
          if (departments != null && departments.length != 0) {
            selectedDepartment = departments[0];
            fetchEmployee(selectedDepartment.DepId.toString()).then((result) {
              setState(() {
                _user = result;
                if (_user != null &&
                    _user.length != 0 &&
                    _user.length > 1) {
                  _user.insert(0, new User(UserNo: 0, UserName: "ALL"));
                  selectedEmployee = _user[0];
                } else if (_user != null && _user.length != 0) {
                  selectedEmployee = _user[0];
                }
              });
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _filteredList = _user.where((item) {
      if (filter == null || filter == '')
        return true;
      else {
        return item.UserName.toLowerCase().contains(filter.toLowerCase());
      }
    }).toList();

    loadingText = "Loading..";
    return CustomProgressHandler(
      isLoading: this.isLoading,
      loadingText: this.loadingText,
      child: Scaffold(
        appBar:AppBar(
          title: Text(AppTranslations.of(context).text("key_mark_attendance")),
        ),
        body: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => setState(() {
                _addItemHeight != 0.0
                    ? _addItemHeight = 0.0
                    : _addItemHeight = 400;
              }),
              child: Container(
                color: Theme.of(context).primaryColorLight,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Filter',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      Icon(
                        Icons.add_circle_outline,
                        color: Theme.of(context).primaryColorDark,
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
               AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  height: _addItemHeight,
                  child:getInputWidgets(context),
                  ),
          ],
        ),
      ),
    );
  }

  Widget getInputWidgets(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 10.0,
            right: 10.0,
            bottom: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Start Date",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: Colors.grey[700],
                                  ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                child: Text(
                                  DateFormat('dd-MMM-yyyy').format(startDate),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                        color: Colors.grey[700],
                                      ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 8.0,
                              ),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  _selectStartDate(context);
                                },
                                child: Icon(
                                  Icons.date_range,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "End date",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: Colors.grey[700],
                                  ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                child: Text(
                                  DateFormat('dd-MMM-yyyy').format(endDate),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                        color: Colors.grey[700],
                                      ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 8.0,
                              ),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  _selectEndDate(context);
                                },
                                child: Icon(
                                  Icons.date_range,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (departments == null) {
                          FlushbarMessage.show(
                            context,
                            AppTranslations.of(context)
                                .text("key_add_department_not_available"),
                            MessageTypes.WARNING,
                          );
                        } else {
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
                                child: Text(
                                  selectedDepartment != null
                                      ? selectedDepartment.DepEName
                                      : AppTranslations.of(context)
                                          .text("key_select_department"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
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
                      height: 10,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        showAttendanceStatus();
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
                                child: Text(
                                  SelectedAttendanceStatus,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
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
                      height: 10,
                    ),
                    Visibility(
                      visible: appData.user.RoleNo == 1,
                      child: Container(
                        padding: selectedReportType == "Details"
                            ? const EdgeInsets.only(bottom: 3)
                            : const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            if (_user == null) {
                              FlushbarMessage.show(
                                context,
                                "User Not Available.",
                                MessageTypes.ERROR,
                              );
                            } else {
                              //showEmployee();
                              filterController.text = '';
                              _settingModalBottomSheet(context);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(
                                5.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Select User",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            color: Colors.grey[700],
                                            //fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    selectedEmployee != null
                                        ? selectedEmployee.UserName
                                        : '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .body1
                                        .copyWith(
                                          color: Colors.black45,
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
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: selectedReportType == "Details",
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10.0, right: 0.0, top: 5),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              showAttendanceStatus();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(
                                  5.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "Attendance Status",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                              color: Colors.grey[700],
                                              //fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      SelectedAttendanceStatus,
                                      style: Theme.of(context)
                                          .textTheme
                                          .body1
                                          .copyWith(
                                            color: Colors.black45,
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
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        String valMsg = getValidationMessage();
                        if (valMsg != '') {
                          FlushbarMessage.show(
                            context,
                            valMsg,
                            MessageTypes.ERROR,
                          );
                        } else {
                          if (SelectedAttendanceStatus == "ALL") {
                            SelectedAttStatus = "%";
                          } else if (SelectedAttendanceStatus == "Absent") {
                            SelectedAttStatus = "A";
                          } else if (SelectedAttendanceStatus == "Present") {
                            SelectedAttStatus = "P";
                          }
                        }
                      },
                      child: Container(
                        color: Colors.blue[100],
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: Text(
                              "Submit",
                              style: Theme.of(context).textTheme.body1.copyWith(
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getValidationMessage() {
    if (appData.user.RoleNo == 1) {
      if (selectedDepartment == null || selectedDepartment == '')
        return "Please Select Branch";
    }

    if (appData.user.RoleNo == 1) {
      if (selectedEmployee == null || selectedEmployee == '')
        return "Please Select User";
    }
    return '';
  }

  void showClientDepartments() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: CustomCupertinoActionMessage(
          message: AppTranslations.of(context).text("key_current_department"),
        ),
        actions: List<Widget>.generate(
          departments.length,
          (i) => CustomCupertinoActionSheetAction(
            actionText: departments[i].DepEName,
            actionIndex: i,
            onActionPressed: () {
              setState(() {
                selectedDepartment = departments[i];
                this.isLoading = true;
                fetchEmployee(selectedDepartment.DepId.toString())
                    .then((result) {
                  setState(() {
                    _user = result;
                    if (_user != null &&
                        _user.length != 0 &&
                        _user.length > 1) {
                      _user.insert(
                          0, new User(UserNo: 0, UserName: "ALL"));
                      selectedEmployee = _user[0];
                    } else if (_user != null && _user.length != 0) {
                      selectedEmployee = _user[0];
                    }
                  });
                });
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

  Future<List<Department>> fetchDepartment() async {
    List<Department> dept;
    try {
      setState(() {
        isLoading = true;
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {"DepId": appData.user.DepId.toString()};

        Uri fetchDepartmentUri = NetworkHandler.getUri(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                DepartmentUrls.GET_DEPT_LIST,
            params);

        http.Response response = await http.get(fetchDepartmentUri,
            headers: NetworkHandler.getHeader());
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

  void showAttendanceStatus() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: CustomCupertinoActionMessage(
          message: "Attendance Status",
        ),
        actions: List<Widget>.generate(
          attendanceStatus.length,
          (i) => CustomCupertinoActionSheetAction(
            actionText: attendanceStatus[i],
            actionIndex: i,
            onActionPressed: () {
              setState(() {
                SelectedAttendanceStatus = attendanceStatus[i];
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Future<List<User>> fetchEmployee(String deptID) async {
    List<User> employee = [];

    try {
      setState(() {
        isLoading = true;
      });
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        var formatter = new DateFormat('yyyy-MM-dd');
        Map<String, dynamic> params = {"DepId": appData.user.DepId.toString()};
        Uri fetchEmployeeUri = NetworkHandler.getUri(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                UserUrls.GET_EMPLOYEE_FOR_REPORT,
            params);


        http.Response response =
            await http.get(fetchEmployeeUri,  headers: NetworkHandler.getHeader());
        var data = json.decode(response.body);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
            context,
            data["Message"],
            MessageTypes.ERROR,
          );
        } else {
          var parsedJson = data["Data"];
          setState(() {
            List responseData = parsedJson;
            employee = responseData
                .map(
                  (item) => User.fromJson(item),
            )
                .toList();
          });
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
    });

    return employee;
  }

  void showEmployee() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Wrap(
        children: <Widget>[
          CupertinoActionSheet(
            message: CustomCupertinoActionMessage(
              message: "Select Employee",
            ),
            actions: List<Widget>.generate(
                _user == null ? 0 : _user.length,
                (index) => CustomCupertinoActionSheetAction(
                      actionText: _user[index].UserName ?? "",
                      actionIndex: index,
                      onActionPressed: () {
                        setState(() {
                          selectedEmployee = _user[index];
                        });
                        Navigator.pop(context);
                      },
                    )),
          ),
        ],
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Column(
            children: <Widget>[
              ListFilterBar(
                searchFieldController: filterController,
                onCloseButtonTap: () {
                  setState(() {
                    filterController.text = '';
                  });
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: CupertinoActionSheet(
                    message: CustomCupertinoActionMessage(
                      message: "Select Employee",
                    ),
                    actions: List<Widget>.generate(
                        _filteredList == null ? 0 : _filteredList.length,
                        (index) => CustomCupertinoActionSheetAction(
                              actionText: _filteredList[index].UserName ?? "",
                              actionIndex: index,
                              onActionPressed: () {
                                setState(() {
                                  selectedEmployee = _filteredList[index];
                                });
                                Navigator.pop(context);
                              },
                            )),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
