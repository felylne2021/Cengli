import 'package:cengli/data/modules/membership/membership_remote_data_store.dart';

import '../../bloc/membership/membership.dart';
import '../../data/modules/membership/membership_remote_repository.dart';
import '../injector.dart';

void injectMembershipModule() {
  locator.registerSingleton<MembershipRemoteRepository>(
      MembershipRemoteDataStore(locator.get()));
  locator.registerSingleton(MembershipBloc(locator.get()));
}
