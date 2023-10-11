import '../auth/model/user_profile.dart';

abstract class MembershipRemoteRepository {
  Future<UserProfile?> searchUser(String? username, String? address);
}
