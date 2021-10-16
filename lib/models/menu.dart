import '../handlers/string_handlers.dart';

class Menu {
  int Number;
  String Name;
  List<SubMenu> child;

  Menu({
    this.Number,
    this.Name,
    this.child,
  });

  Menu.fromMap(Map<String, dynamic> map) {
    Number = map[MenuConst.NumberConst] ?? 0;
    Name = map[MenuConst.NameConst] ?? StringHandlers.NotAvailable;
    child = map[MenuConst.childConst] != null
        ? (map[MenuConst.childConst] as List)
            .map((e) => SubMenu.fromMap(e))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        MenuConst.childConst: child,
        MenuConst.NumberConst: Number,
        MenuConst.NameConst: Name,
      };
  Map<String, dynamic> convertToJson() => <String, dynamic>{
        MenuConst.NumberConst: Number,
        MenuConst.NameConst: Name,
      };

  static Map<String, dynamic> saveToJson(String str) => <String, dynamic>{
        'MenuText': str,
      };
}

class MenuConst {
  static const String NumberConst = "ParentID";
  static const String NameConst = "name";
  static const String childConst = "child";
}

class MenuUrls {
  static const String GET_MENUS = "Menu/GetMenu";
}

class SubMenu {
  int actionno, parent;
  String action_desc;

  SubMenu({
    this.actionno,
    this.parent,
    this.action_desc,
  });

  SubMenu.fromMap(Map<String, dynamic> map) {
    actionno = map[SubMenuConst.actionnoConst] ?? 0;
    parent = map[SubMenuConst.parentConst] ?? 0;
    action_desc =
        map[SubMenuConst.action_descConst] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        SubMenuConst.actionnoConst: actionno,
        SubMenuConst.parentConst: parent,
        SubMenuConst.action_descConst: action_desc,
      };
}

class SubMenuConst {
  static const String actionnoConst = "actionno";
  static const String action_descConst = "action_desc";
  static const String parentConst = "parent";
}
