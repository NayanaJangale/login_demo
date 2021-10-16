import 'package:pulse_india/handlers/string_handlers.dart';
class Attendance {
  int AttendanceId;
  int UserNo;
  DateTime EntDate;
  String EntType ;
  int DepId;
  String Longitude;
  String Latitude ;
  String Address;
  String IsNet;
  String Selfie;




  Attendance({
    this.AttendanceId,
    this.UserNo,
    this.EntDate,
    this.EntType,
    this.DepId,
    this.Longitude,
    this.Latitude,
    this.Address,
    this.IsNet,
    this.Selfie
  });

  factory Attendance.fromJson(Map<String, dynamic> parsedJson) {
    return Attendance(
      AttendanceId: parsedJson[AttendanceConst.AttendanceId] ?? 0,
        UserNo: parsedJson[AttendanceConst.UserNo] ?? 0,
        EntDate: parsedJson["EntDate"] != null
            ? DateTime.parse(parsedJson["EntDate"])
            : null,
        EntType:
            parsedJson[AttendanceConst.EntType] ?? StringHandlers.NotAvailable,
      DepId:
            parsedJson[AttendanceConst.DepId] ?? 0,
      Longitude: parsedJson[AttendanceConst.Longitude] ??
            StringHandlers.NotAvailable,
      Latitude:
            parsedJson[AttendanceConst.Latitude] ?? StringHandlers.NotAvailable,
        Address:
            parsedJson[AttendanceConst.Address] ?? StringHandlers.NotAvailable,
        IsNet : parsedJson[AttendanceConst.IsNet] ?? StringHandlers.NotAvailable,
      Selfie : parsedJson[AttendanceConst.Selfie] ?? StringHandlers.NotAvailable,

    );
  }
  Map<String, dynamic> toJson() => <String, dynamic>{
        AttendanceConst.AttendanceId: AttendanceId,
        AttendanceConst.UserNo: UserNo,
        AttendanceConst.EntDate:
            EntDate == null ? null : EntDate.toIso8601String(),
        AttendanceConst.EntType: EntType,
        AttendanceConst.DepId: DepId,
       AttendanceConst.Longitude: Longitude,
        AttendanceConst.Latitude: Latitude,
        AttendanceConst.Address: Address,
       AttendanceConst.IsNet: IsNet,
       AttendanceConst.Selfie: Selfie ?? null,

      };


}

class AttendanceConst {
  static const String UserNo = "UserNo";
  static const String AttendanceId = "AttendanceId";
  static const String EntDate = "EntDate";
  static const String EntType = "EntType";
  static const String DepId = "DepId";
  static const String Longitude = "Longitude";
  static const String Latitude = "Latitude";
  static const String IsNet = "IsNet";
  static const String Address = "Address";
  static const String Selfie = "Selfie";
}

class AttendanceUrls {
  static const String POST_ATTENDANCE = "Attendance/PostAttendance";
}
