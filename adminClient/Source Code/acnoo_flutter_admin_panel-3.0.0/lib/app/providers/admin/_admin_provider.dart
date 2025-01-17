import 'package:flutter/cupertino.dart';

import '../../models/admin/admin.dart';
class AdminProvider extends ChangeNotifier{
  Admin? _admin;
  Admin? get admin => _admin;

  void setAdmin(Admin admin){
    _admin = admin;
  }
}