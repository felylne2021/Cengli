import 'package:cengli/data/modules/transfer/model/request/transfer_request.dart';
import 'package:cengli/data/modules/transfer/model/response/assets_response.dart';
import 'package:cengli/data/modules/transfer/model/response/chain_response.dart';
import 'package:cengli/data/modules/transfer/model/response/order_response.dart';
import 'package:cengli/data/modules/transfer/model/response/transfer_response.dart';
import 'package:cengli/data/modules/transfer/remote/transfer_api.dart';
import 'package:cengli/data/modules/transfer/transfer_remote_repository.dart';
import 'package:cengli/data/utils/collection_util.dart';
import 'package:cengli/error/error_handler.dart';
import 'package:velix/velix.dart';

import 'model/response/transaction_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class TransferRemoteDataStore extends TransferRemoteRepository {
  final TransferApi _api;
  final firestore.FirebaseFirestore _firestoreDb;

  TransferRemoteDataStore(this._api, this._firestoreDb);

  @override
  Future<AssetsResponse> getAssets(String address, int chainId) async {
    return await _api.getAssets(address, chainId).catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<List<ChainResponse>> getChains() async {
    return await _api.getChains().catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<List<TransactionResponse>> getTransactions(String userId) async {
    return await _api.getTransactions(userId).catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<void> createOrder(OrderResponse order) async {
    await _firestoreDb
        .collection(CollectionEnum.orders.name)
        .add(order.toJson())
        .catchError((error) {
      firebaseErrorHandler(error);
    });
  }

  @override
  Future<void> updateOrder(String id, String status) async {
    await _firestoreDb
        .collection(CollectionEnum.orders.name)
        .doc(id)
        .update({'status': status}).catchError((error) {
      firebaseErrorHandler(error);
    });
  }

  @override
  Future<OrderResponse> getOrder(String groupId) async {
    final documents = await _firestoreDb
        .collection(CollectionEnum.orders.name)
        .where("group_id", isEqualTo: groupId)
        .limit(1)
        .get()
        .catchError((error) {
      firebaseErrorHandler(error);
    });
    return OrderResponse.fromJson(documents.docs.first.data());
  }

  @override
  Future<TransferResponse> postTransfer(TransferRequest param) async {
    return await _api.postTransfer(param).catchError((error) {
      errorHandler(error);
    });
  }
}
