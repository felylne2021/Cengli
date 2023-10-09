import 'package:cengli/bloc/transactional/transactional.dart';
import 'package:cengli/data/transactional/transactional_local_data_store.dart';
import 'package:cengli/data/transactional/transactional_local_repository.dart';
import 'package:cengli/di/injector.dart';

import '../../data/transactional/transactional_remote_data_store.dart';
import '../../data/transactional/transactional_remote_repository.dart';

void injectTransactionModule() {
  locator.registerSingleton<TransactionalLocalRepository>(
      TransactionalLocalDataStore(locator.get()));
  locator.registerSingleton<TransactionalRemoteRepository>(
      TransactionalDataStore(locator.get(), locator.get()));
  locator.registerSingleton(TransactionalBloc(locator.get(), locator.get()));
}
