import 'package:cengli/data/modules/transfer/model/request/create_order_request.dart';
import 'package:cengli/data/modules/transfer/model/request/prepare_erc20_request.dart';
import 'package:cengli/data/modules/transfer/model/request/prepare_tx_request.dart';
import 'package:cengli/data/modules/transfer/model/request/transfer_request.dart';
import 'package:cengli/data/modules/transfer/model/request/usdc_prepare_request.dart';
import 'package:cengli/data/modules/transfer/model/response/assets_response.dart';
import 'package:cengli/data/modules/transfer/model/response/chain_response.dart';
import 'package:cengli/data/modules/transfer/model/response/get_bridge_response.dart';
import 'package:cengli/data/modules/transfer/model/response/order_response.dart';
import 'package:cengli/data/modules/transfer/model/response/get_partners_response.dart';
import 'package:cengli/data/modules/transfer/model/response/transaction_data_response.dart';
import 'package:cengli/data/modules/transfer/model/response/transfer_response.dart';
import 'package:cengli/data/modules/transfer/model/response/update_order_response.dart';
import 'package:cengli/data/modules/transfer/remote/transfer_api.dart';
import 'package:cengli/data/modules/transfer/transfer_remote_repository.dart';
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
  Future<TransferResponse> postTransfer(TransferRequest param) async {
    return await _api.postTransfer(param).catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<List<GetPartnersResponse>> getPartners() async {
    return await _api.getPartners().catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<OrderResponse> postOrder(CreateOrderRequest param) async {
    return await _api.postOrder(param).catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<OrderResponse> getOrder(String orderId) async {
    return await _api.getOrder(orderId).catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<UpdateOrderResponse> acceptOrder(
      String orderId, String callerUserId) async {
    return await _api.acceptOrder(orderId, callerUserId).catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<UpdateOrderResponse> cancelOrder(
      String orderId, String callerUserId) async {
    return await _api.cancelOrder(orderId, callerUserId).catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<UpdateOrderResponse> payOrder(
      String orderId, String callerUserId) async {
    return await _api
        .donePaymentOrder(orderId, callerUserId)
        .catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<UpdateOrderResponse> fundOrder(
      String orderId, String callerUserId) async {
    return await _api
        .releaseFundOrder(orderId, callerUserId)
        .catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<String> prepareTx(PrepareErc20Request param) async {
    return await _api.prepareTx(param).catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<TransactionDataResponse> prepareComethTx(
      PrepareTxRequest param) async {
    return await _api.prepareComethTx(param).catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<GetBridgeResponse> getBridge(
      int fromChainId, int destinationChainId) async {
    return await _api
        .getBridge(fromChainId, destinationChainId)
        .catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<String> prepareUsdcTx(UsdcPrepareRequest param) async {
    return await _api.prepareUsdcTx(param).catchError((error) {
      errorHandler(error);
    });
  }
}
