import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pulse_india/models/user.dart';
import 'package:sqflite/sqflite.dart';

class DBHandler {
  static const int DB_VERSION = 9;
  static Database _db;
  static const String DB_NAME = 'DigitalAttde.db';
  static const String TABLE_USER_MASTER = 'user_master';
  static const String TABLE_MENU_MASTER = 'MenuMaster';
  static const String TABLE_NOTIFICATION_MASTER = 'NotificationMaster';
  static const String TABLE_CURRENT_BRNACH_MASTER = 'CurrentBranchMaster';
  static const String TABLE_BRNACH_MASTER = 'BranchMaster';
  static const String TABLE_ATTENDANCE_MASTER = 'AttendanceMaster';
  static const String TABLE_ATTENDANCE_SELFY_FLAG = 'SelfyMaster';
  static const String TABLE_PURPOSE_MASTER = 'PurposeMaster';
  static const String TABLE_ATTENDANCE_CONFIGRATION = 'ConfigrationMaster';
  static const String TRUE = 'true';
  String UserStatus;
  int is_logged_in;

  static const String CREATE_USER_MASTER_TABLE =
      'CREATE TABLE $TABLE_USER_MASTER (' +
          '${UserFieldNames.UserNo} INTEGER,' +
          '${UserFieldNames.UserName} TEXT,' +
          '${UserFieldNames.Brcode} TEXT,' +
          '${UserFieldNames.UserID} TEXT,' +
          '${UserFieldNames.UserPass} TEXT,' +
          '${UserFieldNames.ClientId} INTEGER,' +
          '${UserFieldNames.RoleNo} INTEGER,' +
          '${UserFieldNames.DesigId} INTEGER,' +
          '${UserFieldNames.ShiftId} INTEGER,' +
          '${UserFieldNames.ContactNo} TEXT,' +
          '${UserFieldNames.is_logged_in} INTEGER,' +
          '${UserFieldNames.SelfyFlag} INTEGER,' +
          '${UserFieldNames.DepId} INTEGER,' +
          '${UserFieldNames.DeviceId} TEXT,' +
          '${UserFieldNames.ReportingOfficer} INTEGER,' +
          '${UserFieldNames.InterBrFlag} INTEGER,' +
          '${UserFieldNames.DepEName} TEXT,' +
          '${UserFieldNames.ShiftName} TEXT)';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDatabase();
    }
    return _db;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(
      path,
      version: DB_VERSION,
      onCreate: _onCreate,
    );
    return db;
  }

  _onCreate(Database db, int version) async {
    //Create User TABLE_USER
    await db.execute(CREATE_USER_MASTER_TABLE);
  }

  Future<User> saveUser(User user) async {
    try {
      var dbClient = await db;
      await dbClient.insert(
        TABLE_USER_MASTER,
        user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<User> login(User user) async {
    try {
      var dbClient = await db;
      user.is_logged_in = 1;

      await dbClient.update(
        TABLE_USER_MASTER,
        user.toJson(),
        where:
            '${UserFieldNames.UserID} = ? AND ${UserFieldNames.UserPass} = ?',
        whereArgs: [
          user.UserID,
          user.UserPass,
        ],
      );

      User updatedUser = await getUser(user.UserID, user.UserPass);
      return updatedUser;
    } catch (e) {
      return null;
    }
  }

  Future<User> logout(User user) async {
    try {
      var dbClient = await db;
      //user.Login_Status = 'false';
      user.is_logged_in = 0;
      await dbClient.delete(
        TABLE_USER_MASTER,
        where: "${UserFieldNames.UserNo} = ?",
        whereArgs: [user.UserNo],
      );
      await dbClient.delete(TABLE_ATTENDANCE_MASTER);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<User> updateUser(User user) async {
    try {
      var dbClient = await db;
      await dbClient.update(
        TABLE_USER_MASTER,
        user.toJson(),
        where: '${UserFieldNames.UserID} = ?',
        whereArgs: [
          user.UserPass,
        ],
      );
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<User> getLoggedInUser() async {
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient.rawQuery(
        "SELECT * FROM $TABLE_USER_MASTER WHERE ${UserFieldNames.is_logged_in} = 1",
        null,
      );

      return User.fromJson1(maps[0]);
    } catch (e) {
      return null;
    }
  }

  Future<User> getUser(String userID, String userPassword) async {
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient.rawQuery(
        "SELECT * FROM $TABLE_USER_MASTER WHERE ${UserFieldNames.UserID} = ? AND ${UserFieldNames.UserPass} = ?",
        [
          userID,
          userPassword,
        ],
      );

      return User.fromJson1(maps[0]);
    } catch (e) {
      return null;
    }
  }

  Future<List<User>> getUsersList() async {
    try {
      var dbClient = await db;
      final List<Map<String, dynamic>> maps =
          await dbClient.query(TABLE_USER_MASTER);

      List<User> users = [];
      users = maps
          .map(
            (item) => User.fromJson1(item),
          )
          .toList();

      return users;
    } catch (e) {
      return null;
    }
  }
}
