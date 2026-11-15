import 'package:flutter/foundation.dart';

import 'admin_user.dart';

class AdminSession extends ChangeNotifier {
  AdminSession._();
  static final AdminSession instance = AdminSession._();
  AdminUser? user;
  void signIn(AdminUser next) { user = next; notifyListeners(); }
  void signOut() { user = null; notifyListeners(); }
}
