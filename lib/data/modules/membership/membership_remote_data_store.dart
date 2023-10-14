import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/data/modules/membership/membership_remote_repository.dart';
import 'package:cengli/data/modules/transactional/model/group.dart';
import 'package:cengli/error/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../../utils/collection_util.dart';

class MembershipRemoteDataStore extends MembershipRemoteRepository {
  final firestore.FirebaseFirestore _firestoreDb;

  MembershipRemoteDataStore(this._firestoreDb);

  @override
  Future<UserProfile?> searchUser(String? username, String? address) async {
    if (username == null) {
      final docs = await _firestoreDb
          .collection(CollectionEnum.users.name)
          .where('walletAddress', isEqualTo: address)
          .get()
          .catchError((error) {
        firebaseErrorHandler(error);
      });
      if (docs.docs.isNotEmpty) {
        return UserProfile.fromJson(docs.docs.first.data());
      } else {
        return null;
      }
    } else {
      final docs = await _firestoreDb
          .collection(CollectionEnum.users.name)
          .where('userName', isEqualTo: username)
          .get()
          .catchError((error) {
        firebaseErrorHandler(error);
      });
      if (docs.docs.isNotEmpty) {
        return UserProfile.fromJson(docs.docs.first.data());
      } else {
        return null;
      }
    }
  }

  @override
  Future<Group?> getGroupFireStore(String id) async {
    final doc = await _firestoreDb
        .collection(CollectionEnum.groups.name)
        .doc(id)
        .get()
        .catchError((error) {
      firebaseErrorHandler(error);
    });
    if (doc.exists) {
      return Group.fromJson(doc.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<List<UserProfile>> getGroupMembersInfo(List<String> ids) async {
    List<UserProfile> users = [];
    for (String id in ids) {
      final doc = await _firestoreDb
          .collection(CollectionEnum.users.name)
          .doc(id)
          .get()
          .catchError((error) {
        firebaseErrorHandler(error);
      });
      if (doc.exists) {
        users.add(UserProfile.fromJson(doc.data()!));
      }
    }
    return users;
  }

  @override
  Future<List<UserProfile>> fetchPartners() async {
    final doc = await _firestoreDb
        .collection(CollectionEnum.users.name)
        .where("userRole", isEqualTo: UserRoleEnum.partner.name)
        .get()
        .catchError((error) {
      firebaseErrorHandler(error);
    });

    return doc.docs.map((value) => UserProfile.fromJson(value.data())).toList();
  }
}
