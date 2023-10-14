import 'package:cengli/data/modules/transfer/remote/transfer_api.dart';
import 'package:cengli/data/modules/transfer/remote/transfer_api_client.dart';
import 'package:cengli/data/modules/transfer/transfer_remote_repository.dart';
import 'package:cengli/di/injector.dart';
import 'package:dio/dio.dart';

import '../../bloc/transfer/transfer.dart';
import '../../data/modules/transfer/transfer_remote_data_store.dart';

void injectTransferModule() {
  locator.registerSingleton(
      TransferApiClient(locator<Dio>(instanceName: "cengli")));
  locator.registerSingleton(TransferApi(locator.get()));
  locator.registerSingleton<TransferRemoteRepository>(
      TransferRemoteDataStore(locator.get(), locator.get()));
  locator.registerSingleton(TransferBloc(locator.get(), locator.get()));
}
