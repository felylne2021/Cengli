import 'package:cengli/bloc/auth/auth.dart';
import 'package:cengli/data/modules/auth/auth_remote_data_store.dart';
import 'package:cengli/data/modules/auth/auth_remote_repository.dart';
import 'package:cengli/data/modules/auth/remote/auth_api.dart';
import 'package:cengli/data/modules/auth/remote/auth_api_client.dart';
import 'package:cengli/di/injector.dart';
import 'package:dio/dio.dart';

void injectAuthModule() {
  locator
      .registerSingleton(AuthApiClient(locator<Dio>(instanceName: "commeth")));
  locator.registerSingleton(AuthApi(locator.get()));
  locator.registerSingleton<AuthRemoteRepository>(
      AuthRemoteDataStore(locator.get(), locator.get()));
  locator.registerSingleton(AuthBloc(locator.get()));
}
