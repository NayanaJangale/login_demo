
import 'package:pulse_india/handlers/string_handlers.dart';

class AttendanceSummary {
  int UserNo;
  int  ExtraCount;
  int  HalfDayCount;
  int Holiday;
  int  LateMarkCount;
  int  AbsentCount;
  int  PresentCount;
  int TotalDays;
  String UserName;


  AttendanceSummary({this.UserNo,this.ExtraCount,this.Holiday, this.HalfDayCount, this.LateMarkCount,
      this.AbsentCount,this.PresentCount,  this.TotalDays,
      this.UserName});

  factory AttendanceSummary.fromJson(Map<String, dynamic> parsedJson) {
    return AttendanceSummary(
      UserNo: parsedJson[AttendanceSummaryConst.UserNo] ?? 0,
      ExtraCount: parsedJson[AttendanceSummaryConst.ExtraCount] ?? 0,
      Holiday: parsedJson[AttendanceSummaryConst.Holiday] ?? 0,
      HalfDayCount: parsedJson[AttendanceSummaryConst.HalfDayCount] ?? 0,
      LateMarkCount: parsedJson[AttendanceSummaryConst.LateMarkCount] ?? 0,
      AbsentCount: parsedJson[AttendanceSummaryConst.AbsentCount] ?? 0,
      PresentCount: parsedJson[AttendanceSummaryConst.PresentCount] ?? 0,
      TotalDays: parsedJson[AttendanceSummaryConst.TotalDays] ?? 0, 
      UserName: parsedJson[AttendanceSummaryConst.UserName] ??  StringHandlers.NotAvailable,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    AttendanceSummaryConst.UserNo: UserNo,
    AttendanceSummaryConst.ExtraCount: ExtraCount,
    AttendanceSummaryConst.Holiday: Holiday,
    AttendanceSummaryConst.HalfDayCount: HalfDayCount,
    AttendanceSummaryConst.LateMarkCount: LateMarkCount,
    AttendanceSummaryConst.AbsentCount: AbsentCount,
    AttendanceSummaryConst.PresentCount: PresentCount,
    AttendanceSummaryConst.TotalDays: TotalDays,
    AttendanceSummaryConst.UserName: UserName,
  };
}

class AttendanceSummaryConst {
  static const String ExtraCount = "ExtraCount";
  static const String Holiday = "Holiday";
  static const String HalfDayCount = "HalfDayCount";
  static const String LateMarkCount = "LateMarkCount";
  static const String AbsentCount = "AbsentCount";
  static const String PresentCount = "PresentCount";
  static const String UserNo = "UserNo";
  static const String TotalDays = "TotalDays";
  static const String UserName = "UserName";

}

class AttendanceSummaryUrls {
  static const String ATTENDANCE_REPORT =
      "Report/GetAttendanceSummary";
}
