import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cengli/bloc/membership/membership.dart';
import 'package:cengli/data/modules/membership/membership_remote_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velix/velix.dart';

class MembershipBloc extends Bloc<MembershipEvent, MembershipState> {
  final MembershipRemoteRepository _membershipRemoteRepository;

  MembershipBloc(this._membershipRemoteRepository)
      : super(const MembershipInitiateState()) {
    on<SearchUserEvent>(_onSearchUser, transformer: sequential());
  }

  Future<void> _onSearchUser(
      SearchUserEvent event, Emitter<MembershipState> emit) async {
    emit(const SearchUserLoadingState());
    try {
      if (event.isUsername) {
        final user =
            await _membershipRemoteRepository.searchUser(event.value, null);
        if (user != null) {
          emit(SearchUserSuccessState(user));
        } else {
          emit(const SearchUserErrorState("Invalid"));
        }
      } else {
        final user =
            await _membershipRemoteRepository.searchUser(null, event.value);
        if (user != null) {
          emit(SearchUserSuccessState(user));
        } else {
          emit(const SearchUserErrorState("Invalid"));
        }
      }
    } on AppException catch (error) {
      emit(SearchUserErrorState(error.message));
    } catch (error) {
      emit(SearchUserErrorState(error.toString()));
    }
  }
}
