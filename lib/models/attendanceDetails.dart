
import 'package:pulse_india/handlers/string_handlers.dart';

class AttendanceReport {
  int UserNo;
  String AtStatus;
  DateTime EntDate;
  DateTime Ent_IN;
  DateTime Ent_Out;
  String UserName;
  String DepEName;
  String ExtraHrs;
  String WorkingHrs;



  AttendanceReport({this.UserNo,this.AtStatus, this.EntDate, this.Ent_IN, this.Ent_Out,
  this.UserName,this.DepEName,this.ExtraHrs,this.WorkingHrs});

  factory AttendanceReport.fromJson(Map<String, dynamic> parsedJson) {
    return AttendanceReport(
      UserNo: parsedJson[AttendanceReportConst.UserNo] ??  0,
      AtStatus: parsedJson[AttendanceReportConst.AtStatus] ??  StringHandlers.NotAvailable,
      EntDate:parsedJson[AttendanceReportConst.EntDate] != null
          ? DateTime.parse(parsedJson[AttendanceReportConst.EntDate])
          : null,
      Ent_IN:parsedJson[AttendanceReportConst.Ent_IN] != null
          ? DateTime.parse(parsedJson[AttendanceReportConst.Ent_IN])
          : null,
      Ent_Out:parsedJson[AttendanceReportConst.Ent_Out] != null
          ? DateTime.parse(parsedJson[AttendanceReportConst.Ent_Out])
          : null,
      DepEName: parsedJson[AttendanceReportConst.DepEName] ?? StringHandlers.NotAvailable,
      UserName: parsedJson[AttendanceReportConst.UserName] ??  StringHandlers.NotAvailable,
      ExtraHrs: parsedJson[AttendanceReportConst.ExtraHrs] ??  StringHandlers.NotAvailable,
      WorkingHrs: parsedJson[AttendanceReportConst.WorkingHrs] ??  StringHandlers.NotAvailable,
    );
  }



  Map<String, dynamic> toJson() => <String, dynamic>{
    AttendanceReportConst.UserNo: UserNo,
    AttendanceReportConst.AtStatus: AtStatus,
    AttendanceReportConst.EntDate: EntDate == null ? null : EntDate.toIso8601String(),
    AttendanceReportConst.Ent_IN: Ent_IN,
    AttendanceReportConst.Ent_Out: Ent_Out,
    AttendanceReportConst.DepEName: DepEName,
    AttendanceReportConst.UserName: UserName,
    AttendanceReportConst.ExtraHrs: ExtraHrs,
    AttendanceReportConst.WorkingHrs: WorkingHrs,
  };
}

class AttendanceReportConst {
  static const String AtStatus = "AtStatus";
  static const String EntDate = "EntDate";
  static const String Ent_IN = "Ent_IN";
  static const String Ent_Out = "Ent_Out";
  static const String UserNo = "UserNo";
  static const String UserName = "UserName";
  static const String DepEName = "DepEName";
  static const String ExtraHrs = "ExtraHrs";
  static const String WorkingHrs = "WorkingHrs";

}

class AttendanceReportUrls {
  static const String ATTENDANCE_REPORT ="Report/GetAttendanceDetails";
  static const String DASHBOARD_DETAIL ="Report/GetDashboardAttendanceDetail";
}
