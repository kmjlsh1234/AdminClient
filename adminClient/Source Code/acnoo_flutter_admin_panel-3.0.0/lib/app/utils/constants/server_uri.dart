class ServerUri{

  static const String BASE_URL = "http://localhost:38084";
  //AUTH
  static const String TOKEN_CHECK = "/admin/token/check";
  static const String ADMIN_LOGOUT = "/admin/logout";
  //MENU
  static const String MENU_LIST = "/admin/v1/menus";

  //ADMIN MANAGE
  static const String ADMIN_INFO = "/admin/v1/admins/self";
  static const String ADMIN_LIST = "/admin/v1/admins/list";
  static const String ADMIN_LIST_COUNT = "/admin/v1/admins/list/count";
  static const String ADMIN_ADD = "/admin/v1/admins";
  static const String ADMIN_MOD = "/admin/v1/admins/{adminId}";

}