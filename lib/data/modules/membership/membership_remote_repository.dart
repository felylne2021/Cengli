
import '../auth/model/user_profile.dart';
import '../transactional/model/group.dart';

abstract class MembershipRemoteRepository {
  Future<UserProfile?> searchUser(String? username, String? address);
  Future<Group?> getGroupFireStore(String id);
  Future<List<UserProfile>> getGroupMembersInfo(List<String> ids);
}
