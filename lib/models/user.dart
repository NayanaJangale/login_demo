import 'package:pulse_india/handlers/string_handlers.dart';

class User {
  int UserNo;
  String UserName;
  String Brcode;
  String UserID;
  String UserPass;
  int ClientId;
  int RoleNo;
  int DesigId;
  int ShiftId;
  String ContactNo;
  int is_logged_in;
  bool SelfyFlag;
  int DepId;
  String DeviceId;
  int ReportingOfficer;
  bool InterBrFlag;
  String DepEName;
  String ShiftName;
  User({
      this.UserNo,
      this.UserName,
      this.Brcode,
      this.UserID,
      this.UserPass,
      this.ClientId,
      this.RoleNo,
      this.DesigId,
      this.ShiftId,
      this.ContactNo,
      this.is_logged_in,
      this.SelfyFlag,
      this.DepId,
      this.DeviceId,
      this.ReportingOfficer,
      this.InterBrFlag,
      this.DepEName,
      this.ShiftName});

  User.fromJson(Map<String, dynamic> map) {
    UserNo = map[UserFieldNames.UserNo] ?? 0;
    UserName = map[UserFieldNames.UserName] ?? '';
    Brcode = map[UserFieldNames.Brcode] ?? '';
    UserID = map[UserFieldNames.UserID] ?? '';
    UserPass = map[UserFieldNames.UserPass] ?? '';
    ClientId = map[UserFieldNames.ClientId] ?? 0;
    RoleNo = map[UserFieldNames.RoleNo] ?? 0;
    DesigId = map[UserFieldNames.DesigId] ?? 0;
    ShiftId = map[UserFieldNames.ShiftId] ?? 0;
    ContactNo = map[UserFieldNames.ContactNo] ?? '';
    is_logged_in = map[UserFieldNames.is_logged_in] ?? 0;
    SelfyFlag = map[UserFieldNames.SelfyFlag] ?? false;
    DepId = map[UserFieldNames.DepId] ?? 0;
    DeviceId = map[UserFieldNames.DeviceId] ?? '';
    ReportingOfficer = map[UserFieldNames.ReportingOfficer] ?? 0;
    InterBrFlag = map[UserFieldNames.InterBrFlag] ?? false;
    DepEName = map[UserFieldNames.DepEName] ??'';
    ShiftName = map[UserFieldNames.ShiftName] ??'';
  }
  User.fromJson1(Map<String, dynamic> map) {
    UserNo = map[UserFieldNames.UserNo] ?? 0;
    UserName = map[UserFieldNames.UserName] ?? '';
    Brcode = map[UserFieldNames.Brcode] ?? '';
    UserID = map[UserFieldNames.UserID] ?? '';
    UserPass = map[UserFieldNames.UserPass] ?? '';
    ClientId = map[UserFieldNames.ClientId] ?? 0;
    RoleNo = map[UserFieldNames.RoleNo] ?? 0;
    DesigId = map[UserFieldNames.DesigId] ?? 0;
    ShiftId = map[UserFieldNames.ShiftId] ?? 0;
    ContactNo = map[UserFieldNames.ContactNo] ?? '';
    is_logged_in = map[UserFieldNames.is_logged_in] ?? 0;
    SelfyFlag = map[UserFieldNames.SelfyFlag]== 1 ? true: false;
    DepId = map[UserFieldNames.DepId] ?? 0;
    DeviceId = map[UserFieldNames.DeviceId] ?? '';
    ReportingOfficer = map[UserFieldNames.ReportingOfficer] ?? 0;
    InterBrFlag = map[UserFieldNames.InterBrFlag] ==1? true: false;
    DepEName = map[UserFieldNames.DepEName] ??'';
    ShiftName = map[UserFieldNames.ShiftName] ??'';
  }


  Map<String, dynamic> toJson() => <String, dynamic>{
        UserFieldNames.UserNo: UserNo,
        UserFieldNames.UserName: UserName,
        UserFieldNames.Brcode: Brcode,
        UserFieldNames.UserID: UserID,
        UserFieldNames.UserPass: UserPass,
        UserFieldNames.ClientId: ClientId,
        UserFieldNames.RoleNo: RoleNo,
        UserFieldNames.DesigId: DesigId,
        UserFieldNames.ShiftId: ShiftId,
        UserFieldNames.ContactNo: ContactNo,
        UserFieldNames.is_logged_in : is_logged_in,
        UserFieldNames.SelfyFlag: SelfyFlag ? 1:0 ,
        UserFieldNames.DepId: DepId,
        UserFieldNames.DeviceId: DeviceId,
        UserFieldNames.ReportingOfficer: ReportingOfficer,
        UserFieldNames.InterBrFlag: InterBrFlag ? 1:0 ,
        UserFieldNames.DepEName: DepEName,
        UserFieldNames.ShiftName: ShiftName,

      };
}

class UserFieldNames {
  static const String UserNo = "UserNo";
  static const String UserName = "UserName";
  static const String DesigId = "DesigId";
  static const String ShiftId = "ShiftId";
  static const String SelfyFlag = "SelfyFlag";
  static const String DepId = "DepId";
  static const String DeviceId = "DeviceId";
  static const String ReportingOfficer = "ReportingOfficer";
  static const String DepEName = "DepEName";
  static const String ShiftName = "ShiftName";
  static const String InterBrFlag = "InterBrFlag";
  static const String Brcode = "Brcode";
  static const String UserID = "UserID";
  static const String UserPass = "UserPass";
  static const String MobileNo = "MobileNo";
  static const String ClientId = "ClientId";
  static const String RoleNo = "RoleNo";
  static const String RefUserNo = "RefUserNo";
  static const String ContactNo = 'ContactNo';
  static const String UserStatus = 'UserStatus';
  static const String is_logged_in = 'is_logged_in';

  static const String OldPassword = "OldPassword";
  static const String NewPassword = "NewPassword";
}

class UserUrls {
  static const String GET_USER = 'Users/GetEmployeeDetails';
  static const String POST_UNIQUE_ID = 'Users/PostDeviceIdAndPassword';
  static const String CHANGE_PARENT_PASSWORD = 'Users/ChangeEmployeePassword';
  static const String GET_EMPLOYEE_FOR_REPORT ="Attendance/GetDepartwiseEmployee";

}
