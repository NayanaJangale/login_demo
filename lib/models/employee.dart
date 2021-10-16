class Employee {
  int UserNo;
  String UserName;


  Employee({
    this.UserNo,
    this.UserName,
  
  });

  Employee.fromMap(Map<String, dynamic> map) {
    UserNo = map[EmployeeConst.UserNo];
    UserName = map[EmployeeConst.UserName];
  }
  factory Employee.fromJson(Map<String, dynamic> parsedJson) {
    return Employee(
      UserNo: parsedJson[EmployeeConst.UserNo],
      UserName: parsedJson[EmployeeConst.UserName],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    EmployeeConst.UserNo: UserNo,
    EmployeeConst.UserName: UserName,
  };
}

class EmployeeConst {
  static const String UserNo = "UserNo";
  static const String UserName = "UserName";
}

class EmployeeUrls {
  static const String GET_EMPLOYEE_FOR_REPORT ="Attendance/GetDepartwiseEmployee";
}
