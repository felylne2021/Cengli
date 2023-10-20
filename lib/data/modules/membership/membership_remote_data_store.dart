import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/data/modules/membership/membership_remote_repository.dart';
import 'package:cengli/data/modules/membership/model/registration.dart';
import 'package:cengli/data/modules/membership/model/request/send_notif_request.dart';
import 'package:cengli/data/modules/membership/model/request/subscribe_channel_request.dart';
import 'package:cengli/data/modules/membership/model/request/upsert_fcm_token_request.dart';
import 'package:cengli/data/modules/membership/model/response/upsert_fcm_token_response.dart';
import 'package:cengli/data/modules/membership/remote/membership_api.dart';
import 'package:cengli/data/modules/transactional/model/group.dart';
import 'package:cengli/error/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:velix/velix.dart';

import '../../utils/collection_util.dart';

class MembershipRemoteDataStore extends MembershipRemoteRepository {
  final firestore.FirebaseFirestore _firestoreDb;
  final MembershipApi _api;

  MembershipRemoteDataStore(this._firestoreDb, this._api);

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
  Future<void> updateUsername(
      String fullname, String username, String userId) async {
    await _firestoreDb
        .collection(CollectionEnum.users.name)
        .doc(userId)
        .update({"name": fullname, "userName": username}).catchError((error) {
      firebaseErrorHandler(error);
    });
  }

  @override
  Future<UpsertFcmTokenResponse> upsertFcmToken(
      UpsertFcmTokenRequest param) async {
    return await _api.upsertFcmToken(param).catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<void> subscribeChannel(SubscribeChannelRequest param) async {
    await _api.subscribeChannel(param).catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<void> sendNotification(SendNotifRequest param) async {
    await _api.sendNotification(param).catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<List<Group>?> getListOfGroup(String userId) async {
    List<Group>? groups = [];
    final documents = await _firestoreDb
        .collection(CollectionEnum.groups.name)
        .where('members', arrayContains: userId)
        .get()
        .catchError((error) {
      firebaseErrorHandler(error);
    });

    for (var doc in documents.docs) {
      groups.add(Group.fromJson(doc.data()));
    }

    return groups;
  }

  Future<Registration?> getRegistrationPartner(String walletAddress) async {
    final doc = await _firestoreDb
        .collection(CollectionEnum.registration.name)
        .where('walletAddress', isEqualTo: walletAddress)
        .limit(1)
        .get();
    if (doc.docs.isNotEmpty) {
      return Registration.fromJson(doc.docs.first.data());
    } else {
      return null;
    }
  }

  @override
  Future<void> registPartner(String walletAddress) async {
    await _firestoreDb
        .collection(CollectionEnum.registration.name)
        .add(Registration(
                walletAddress: walletAddress,
                status: RegistrationStatusEnum.onproses.name)
            .toJson())
        .catchError((error) {
      firebaseErrorHandler(error);
    });
  }
}
