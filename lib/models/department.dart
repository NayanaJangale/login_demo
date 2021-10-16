
import 'package:pulse_india/handlers/string_handlers.dart';

class Department {
  int DepId;
  String DepEName;
  String DepAEName;
  double distance;
  int FloorNo;
  String latitude;
  String longitude;
  Department({this.DepId, this.DepEName, this.DepAEName,this.distance,this.FloorNo,this.latitude,this.longitude});

  factory Department.fromJson(Map<String, dynamic> parsedJson) {
    return Department(
      DepId: parsedJson[DepartmentConst.DepId]?? 0,
      DepEName: parsedJson[DepartmentConst.DepEName]?? StringHandlers.NotAvailable,
      DepAEName: parsedJson[DepartmentConst.DepAEName]?? StringHandlers.NotAvailable,
      distance: parsedJson[DepartmentConst.distance]?? 0.0,
      FloorNo: parsedJson[DepartmentConst.FloorNo]?? 0,
      latitude: parsedJson[DepartmentConst.latitude]?? StringHandlers.NotAvailable,
      longitude: parsedJson[DepartmentConst.longitude]?? StringHandlers.NotAvailable,

    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    DepartmentConst.DepId: DepId,
    DepartmentConst.DepEName: DepEName,
    DepartmentConst.DepAEName: DepAEName,
    DepartmentConst.distance: distance,
    DepartmentConst.FloorNo: FloorNo,
    DepartmentConst.latitude: latitude,
    DepartmentConst.longitude: longitude,
  };



}
class DepartmentConst {
  static const String DepId = "DepId";
  static const String DepEName = "DepEName";
  static const String DepAEName = "DepAEName";
  static const String distance = "distance";
  static const String FloorNo = "FloorNo";
  static const String latitude = "latitude";
  static const String longitude = "longitude";
}
class DepartmentUrls {
  static const String GET_DEPT_FOR_OFFICE = 'Attendance/GetClientForOfficeAtt';
  static const String GET_DEPT_LIST = 'Attendance/GetDepartmentlist';
}
