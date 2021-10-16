import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pulse_india/app_data.dart';
import 'package:pulse_india/components/custom_cupertino_action.dart';
import 'package:pulse_india/components/custom_cupertino_action_message.dart';
import 'package:pulse_india/components/custom_gradient_button.dart';
import 'package:pulse_india/components/custom_progress_handler.dart';
import 'package:pulse_india/components/custom_sppiner.dart';
import 'package:pulse_india/components/flushbar_message.dart';
import 'package:pulse_india/components/list_filter_bar.dart';
import 'package:pulse_india/components/not_found_widget.dart';
import 'package:pulse_india/constants/http_status_codes.dart';
import 'package:pulse_india/constants/message_types.dart';
import 'package:pulse_india/constants/project_settings.dart';
import 'package:pulse_india/handlers/network_handler.dart';
import 'package:pulse_india/handlers/string_handlers.dart';
import 'package:pulse_india/localization/app_translations.dart';
import 'package:pulse_india/models/attendanceDetails.dart';
import 'package:pulse_india/models/attendanceSummary.dart';
import 'package:pulse_india/models/department.dart';
import 'package:pulse_india/models/user.dart';


class AttendanceReportPage extends StatefulWidget {

  @override
  _AttendanceReportPageState createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  bool isLoading;
  String loadingText;
  List<AttendanceReport> attendanceReports = [];
  List<AttendanceSummary> summaryReports = [];
  List<Department> departments = [];
  Department selectedDepartment;
  String filter,selectedReportType = "Details", SelectedAttStatus = "ALL" ,deptID,attendancecat;
  List<String> reportType = [
    'Details',
    'Summary',
  ];
  List<String> attendanceStatus = [
    'ALL',
    'Absent',
    'Half Day',
    'Late Mark',
    'Present',
  ];
  List<User> _user = [];
  List<User> _filteredList = [];
  User selectedEmployee;
  TextEditingController filterController;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  double _addItemHeight = 450.0;
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
          AppTranslations.of(context).text("key_date_not_valid"),
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
          AppTranslations.of(context).text("key_date_not_valid"),
          MessageTypes.ERROR,
        );

        setState(() {
          endDate = DateTime.now();
        });
      }
    }
  }
  GlobalKey<ScaffoldState> _AttendanceReportKey =new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _AttendanceReportKey = GlobalKey<ScaffoldState>();
    this.loadingText = 'loading...';
    this.isLoading = false;
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
            departments.insert(0, new Department(DepId: 0, DepEName: "ALL",DepAEName: ""));
             selectedDepartment = departments[0];
            deptID = selectedDepartment.DepId.toString();
            fetchEmployee(deptID).then((result) {
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
    return CustomProgressHandler(
      isLoading: this.isLoading ,
      loadingText: this.loadingText,
      child: Scaffold(
          key: _AttendanceReportKey,
          appBar:AppBar(
            title: Text(AppTranslations.of(context).text("key_attendance_report")),
          ),
          body: RefreshIndicator(
              onRefresh: () async {
                if (selectedReportType == "Details") {
                  fetchAttendaceReport().then((result) {
                    setState(() {
                      attendanceReports = result;
                    });
                  });
                } else {
                  fetchAttendaceSummaryReport().then((result) {
                    setState(() {
                      summaryReports = result;
                    });
                  });
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => setState(() {
                      _addItemHeight != 0.0
                          ? _addItemHeight = 0.0
                          : _addItemHeight = 450;
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
                              AppTranslations.of(context).text("key_filter"),
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
                    child: getInputWidgets(context),
                  ),
                  selectedReportType == "Details"
                      ? getAtendanceDetailReport()
                      : getAtendanceSummaryReport(),
                ],
              ))
      ),
    );
  }
  Widget getAtendanceSummaryReport() {
    int count = 0;
    return summaryReports != null && summaryReports.length != 0
        ? Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 40,
              dataRowHeight: 40,
              columns: [
                DataColumn(
                  label: Text(
                    AppTranslations.of(context).text("key_sr_no"),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppTranslations.of(context).text("key_employee_name"),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppTranslations.of(context).text("key_total_days"),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppTranslations.of(context).text("key_holiday"),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppTranslations.of(context).text("key_present_count"),
                    style: Theme.of(context).textTheme.body1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppTranslations.of(context).text("key_late_mark"),
                    style: Theme.of(context).textTheme.body1.copyWith(
                      color:Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppTranslations.of(context).text("key_half_day"),
                    style: Theme.of(context).textTheme.body1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                DataColumn(
                  label: Text(
                    AppTranslations.of(context).text("key_absent_count"),
                    style: Theme.of(context).textTheme.body1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppTranslations.of(context).text("key_extra_count"),
                    style: Theme.of(context).textTheme.body1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              rows: new List<DataRow>.generate(
                summaryReports.length,
                    (int index) {
                  count++;
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          count.toString(),
                          style:
                          Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataCell(
                        Text(
                          StringHandlers.capitalizeWords(
                              summaryReports[index].UserName),
                          style:
                          Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          summaryReports[index].TotalDays.toString(),
                          style:
                          Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataCell(
                        Text(
                          summaryReports[index].Holiday.toString(),
                          style:
                          Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataCell(
                        Text(
                          summaryReports[index].PresentCount.toString(),
                          style:
                          Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataCell(
                        Text(
                          summaryReports[index].LateMarkCount.toString(),
                          style:
                          Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      DataCell(
                        Text(
                          summaryReports[index].HalfDayCount.toString(),
                          style:
                          Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      DataCell(
                        Text(
                          summaryReports[index].AbsentCount.toString(),
                          style:
                          Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      DataCell(
                        Text(
                          summaryReports[index].ExtraCount.toString(),
                          style:
                          Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    )
        : Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return NotFoundWidget(
                widgetType :"D"
            );
          },
        ),
      ),
    );
  }
  Widget getAtendanceDetailReport() {
    int count = 0;
    return attendanceReports != null && attendanceReports.length != 0
        ? Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 40,
              dataRowHeight: 40,
              columns: [
                DataColumn(
                  label: Text(
                    AppTranslations.of(context).text("key_sr_no"),
                    style: Theme.of(context).textTheme.body1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppTranslations.of(context).text("key_entry_date"),
                    style: Theme.of(context).textTheme.body1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppTranslations.of(context).text("key_employee_name"),
                    style: Theme.of(context).textTheme.body1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppTranslations.of(context).text("key_in_time"),
                    style: Theme.of(context).textTheme.body1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppTranslations.of(context).text("key_out_time"),
                    style: Theme.of(context).textTheme.body1.copyWith(
                      color:Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppTranslations.of(context).text("key_status"),
                    style: Theme.of(context).textTheme.body1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppTranslations.of(context).text("key_working_hours"),
                    style: Theme.of(context).textTheme.body1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppTranslations.of(context).text("key_extra_hours"),
                    style: Theme.of(context).textTheme.body1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppTranslations.of(context).text("key_dept_name"),
                    style: Theme.of(context).textTheme.body1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              rows: new List<DataRow>.generate(
                attendanceReports.length,
                    (int index) {
                  count++;
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          count.toString(),
                          style:
                          Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataCell(
                        Text(
                          attendanceReports[index].EntDate != null
                              ? DateFormat('dd-MMM-yyyy').format(
                              attendanceReports[index].EntDate)
                              : '',
                          style:
                          Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataCell(
                        Text(
                          StringHandlers.capitalizeWords(
                              attendanceReports[index].UserName),
                          style:
                          Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataCell(attendanceReports[index].Ent_IN != null
                          ? Text(
                        DateFormat('hh:mm aaa').format(
                            attendanceReports[index].Ent_IN),
                        style: Theme.of(context)
                            .textTheme
                            .body2
                            .copyWith(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      )
                          : Center(
                        child: Text(
                          '-',
                          style: Theme.of(context)
                              .textTheme
                              .body2
                              .copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )),
                      DataCell(
                        attendanceReports[index].Ent_Out != null
                            ? Text(
                          DateFormat('hh:mm aaa').format(
                              attendanceReports[index].Ent_Out),
                          style: Theme.of(context)
                              .textTheme
                              .body2
                              .copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        )
                            : Center(
                          child: Text(
                            "-",
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .copyWith(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          attendanceReports[index].AtStatus,
                          style:
                          Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      DataCell(
                        Text(
                          attendanceReports[index].WorkingHrs,
                          style:
                          Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      DataCell(
                        Text(
                          attendanceReports[index].ExtraHrs,
                          style:
                          Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      DataCell(
                        Text(
                          attendanceReports[index].DepEName,
                          style:
                          Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    )
        : Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return NotFoundWidget(
                widgetType :"D"
            );
          },
        ),
      ),
    );
  }

  Widget getInputWidgets(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 10.0,
        right: 10.0,
        bottom: 10.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
             // color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppTranslations.of(context).text("key_select_date"),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                color: Colors.grey[700],
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
                                  30.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
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
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(child:   Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppTranslations.of(context).text("key_end_date"),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                              color: Colors.grey[700],
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
                                30.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
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
                        ],
                      ),
                      )

                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomSpinner(
                    visibilityStatus: appData.user.RoleNo==1 ,
                      onActionTapped: (){
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
                      selectedText:  selectedDepartment != null
                          ? selectedDepartment.DepEName
                          : "ALL"

                  ),
                  Visibility(
                    visible: appData.user.RoleNo==1 ,
                    child: SizedBox(
                      height: 10,
                    ),
                  ),
                  CustomSpinner(
                    onActionTapped: (){
                      showReportType();
                    },
                    selectedText: selectedReportType,

                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomSpinner(
                    visibilityStatus: selectedReportType =="Details",
                    onActionTapped: (){
                      showAttendanceStatus();
                    },
                    selectedText: SelectedAttStatus,

                  ),
                  Visibility(
                    visible: selectedReportType =="Details" ,
                    child: SizedBox(
                      height: 10,
                    ),
                  ),
                  CustomSpinner(
                    visibilityStatus: appData.user.RoleNo==1 ,
                    onActionTapped: (){
                      if (_user == null) {
                        FlushbarMessage.show(
                          context,
                          AppTranslations.of(context).text("key_employee_not_available"),
                          MessageTypes.ERROR,
                        );
                      } else {
                        filterController.text = '';
                        _settingModalBottomSheet(context);
                      }
                    },
                    selectedText:  selectedEmployee != null
                        ? selectedEmployee.UserName
                        : 'ALL',

                  ),
                  Visibility(
                    visible: appData.user.RoleNo==1 ,
                    child: SizedBox(
                      height: 10,
                    ),
                  ),
                  CustomGradientButton(
                      caption:
                      AppTranslations.of(context).text("key_submit"),
                      onPressed: () {
                        String valMsg = getValidationMessage();
                        if (valMsg != '') {
                          FlushbarMessage.show(
                            context,
                            valMsg,
                            MessageTypes.WARNING,
                          );
                        } else {
                          if(SelectedAttStatus =="ALL"){
                            attendancecat ="%";

                          }else if (SelectedAttStatus =="Absent"){
                            attendancecat ="A";
                          }else if (SelectedAttStatus =="Half Day"){
                            attendancecat ="HD";
                          }else if (SelectedAttStatus =="Late Mark"){
                            attendancecat ="LM";
                          }else if (SelectedAttStatus =="Present") {
                            attendancecat="P";
                          }
                        }
                        setState(() {
                          _addItemHeight != 0.0
                              ? _addItemHeight = 0.0
                              : _addItemHeight = 450;
                        });
                        if (selectedReportType == "Details") {
                          fetchAttendaceReport().then((result) {
                            setState(() {
                              attendanceReports = result;
                            });
                          });
                        } else {
                          fetchAttendaceSummaryReport().then((result) {
                            setState(() {
                              summaryReports = result;
                            });
                          });
                        }
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  String getValidationMessage() {
    if (appData.user.RoleNo == 1) {
      if (selectedDepartment == null || selectedDepartment == '')
        return  AppTranslations.of(context).text("key_add_department_not_available");
    }

    if (appData.user.RoleNo == 1) {
      if (selectedEmployee == null || selectedEmployee == '')
        return AppTranslations.of(context).text("key_employee_not_available");
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
                deptID = selectedDepartment.DepId!=null?selectedDepartment.DepId.toString():"%";
                fetchEmployee(deptID)
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
          message: AppTranslations.of(context).text("key_report_type"),
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
          message: AppTranslations.of(context).text("key_attendance_status"),
        ),
        actions: List<Widget>.generate(
          attendanceStatus.length,
              (i) => CustomCupertinoActionSheetAction(
            actionText: attendanceStatus[i],
            actionIndex: i,
            onActionPressed: () {
              setState(() {
                SelectedAttStatus = attendanceStatus[i];
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
        Map<String, dynamic> params = {
          "DepId": deptID
        };
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
              message: AppTranslations.of(context).text("key_select_employee"),
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
  Future<List<AttendanceReport>> fetchAttendaceReport() async {
    List<AttendanceReport> attendace = [];
    try {
      setState(() {
        isLoading = true;
      });
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();

      if (connectionServerMsg != "key_check_internet") {
        var formatter = new DateFormat('yyyy-MM-dd');
        Uri fetchStudentAttendanceReportUri = Uri.parse(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              AttendanceReportUrls.ATTENDANCE_REPORT,
        ).replace(
          queryParameters: {
            "sdt": formatter.format(startDate),
            "edt": formatter.format(endDate),
            "DepId": selectedDepartment == null ? appData.user.DepId.toString(): selectedDepartment.DepId.toString(),
            "ClientId": "0",
            "Brcode":"001",
            "AtStatus": attendancecat,
            "UserNo":selectedEmployee == null ? appData.user.UserNo.toString(): selectedEmployee.UserNo.toString(),

          },
        );
        http.Response response =
        await http.get(fetchStudentAttendanceReportUri, headers: NetworkHandler.getHeader());
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
            attendace = responseData
                .map(
                  (item) => AttendanceReport.fromJson(item),
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

    return attendace;
  }
  Future<List<AttendanceSummary>> fetchAttendaceSummaryReport() async {
    List<AttendanceSummary> attendacesummary = [];

    try {
      setState(() {
        isLoading = true;
      });
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        var formatter = new DateFormat('yyyy-MM-dd');
        Uri fetchStudentAttendanceReportUri = Uri.parse(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              AttendanceSummaryUrls.ATTENDANCE_REPORT,
        ).replace(
          queryParameters: {
            "sdt": formatter.format(startDate),
            "edt": formatter.format(endDate),
            "DepId": selectedDepartment == null ? appData.user.DepId.toString(): selectedDepartment.DepId.toString(),
            "ClientId": "0",
            "Brcode":"001",
            "UserNo":selectedEmployee == null ? appData.user.UserNo.toString(): selectedEmployee.UserNo.toString(),


          },
        );

        http.Response response =
        await http.get(fetchStudentAttendanceReportUri, headers: NetworkHandler.getHeader());
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
            attendacesummary = responseData
                .map(
                  (item) => AttendanceSummary.fromJson(item),
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

    return attendacesummary;
  }

}
