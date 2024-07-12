import 'package:go_router/go_router.dart';

class RouterService {
  static GoRouter loggedOutRouter = GoRouter(routes: []);
}

class RouterConstants {
  static const initialScreenRouteName = "initialScreenRouteName";
  static const selectUniversityRouteName = "selectUniversityRouteName";
  static const loginScreenRouteName = "loginScreenRouteName";
  static const homeScreenRouteName = "homeScreenRouteName";
}
