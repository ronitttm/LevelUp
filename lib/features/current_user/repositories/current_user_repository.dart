import '../models/current_user.dart';

abstract class CurrentUserRepository {
  Future<CurrentUser> getCurrentUser();
}
