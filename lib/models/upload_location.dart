
import 'package:pulse_india/handlers/string_handlers.dart';

class UploadLocation {
  int LocationId;
  int DepId;
  int FloorNo;
  String Latitude;
  String Longitude;
  String Altitude;
  String latlongstatus;
  int Radius;


  UploadLocation({this.LocationId, this.DepId, this.FloorNo,
    this.Latitude, this.Longitude, this.Altitude, this.latlongstatus, this.Radius});

  factory UploadLocation.fromJson(Map<String, dynamic> parsedJson) {
    return UploadLocation(
      LocationId: parsedJson[UploadLocationConst.LocationId]?? 0,
      DepId: parsedJson[UploadLocationConst.DepId]?? 0,
      FloorNo: parsedJson[UploadLocationConst.FloorNo]?? 0,
      Latitude: parsedJson[UploadLocationConst.Latitude]?? StringHandlers.NotAvailable,
      Longitude: parsedJson[UploadLocationConst.Longitude]?? StringHandlers.NotAvailable,
      Altitude: parsedJson[UploadLocationConst.Altitude]?? StringHandlers.NotAvailable,
      latlongstatus: parsedJson[UploadLocationConst.latlongstatus]?? StringHandlers.NotAvailable,
      Radius: parsedJson['Radius']?? 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    UploadLocationConst.LocationId: LocationId,
    UploadLocationConst.DepId: DepId,
    UploadLocationConst.FloorNo: FloorNo,
    UploadLocationConst.Latitude: Latitude,
    UploadLocationConst.Longitude: Longitude,
    UploadLocationConst.Altitude: Altitude,
    UploadLocationConst.latlongstatus: latlongstatus,
    UploadLocationConst.Radius :Radius ,
  };



}
class UploadLocationConst {
  static const String FloorNo = "FloorNo";
  static const String LocationId = "LocationId";
  static const String DepId = "DepId";
  static const String Latitude = "Latitude";
  static const String Longitude = "Longitude";
  static const String Altitude = "Altitude";
  static const String latlongstatus = "latlongstatus";
  static const String Radius = "Radius";
}
class DeptLocationUrls {
  static const String POST_DEPT_LOCATION = 'Attendance/PostDepartmentLocation';

}
