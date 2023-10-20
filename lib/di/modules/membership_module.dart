import 'package:cengli/data/modules/membership/membership_remote_data_store.dart';
import 'package:cengli/data/modules/membership/remote/membership_api.dart';
import 'package:cengli/data/modules/membership/remote/membership_client_api.dart';
import 'package:dio/dio.dart';

import '../../bloc/membership/membership.dart';
import '../../data/modules/membership/membership_remote_repository.dart';
import '../injector.dart';

void injectMembershipModule() {
  locator.registerSingleton(
      MembershipApiClient(locator<Dio>(instanceName: "cengli")));
  locator.registerSingleton(MembershipApi(locator.get()));
  locator.registerSingleton<MembershipRemoteRepository>(
      MembershipRemoteDataStore(locator.get(), locator.get()));
  locator.registerSingleton(MembershipBloc(locator.get()));
}
