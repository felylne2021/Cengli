import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/data/modules/membership/membership_remote_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../../utils/collection_util.dart';

class MembershipRemoteDataStore extends MembershipRemoteRepository {
  final firestore.FirebaseFirestore _firestoreDb;

  MembershipRemoteDataStore(this._firestoreDb);

  @override
  Future<UserProfile?> searchUser(
      String? username, String? address) async {
    if (username == null) {
      final docs = await _firestoreDb
          .collection(CollectionEnum.users.name)
          .where('walletAddress', isEqualTo: address)
          .get();
      if (docs.docs.isNotEmpty) {
        return UserProfile.fromJson(docs.docs.first.data());
      } else {
        return null;
      }
    } else {
      final docs = await _firestoreDb
          .collection(CollectionEnum.users.name)
          .where('userName', isEqualTo: username)
          .get();
      if (docs.docs.isNotEmpty) {
        return UserProfile.fromJson(docs.docs.first.data());
      } else {
        return null;
      }
    }
  }
}
