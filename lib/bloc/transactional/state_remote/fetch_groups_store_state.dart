import 'package:cengli/data/transactional/model/group.dart';
import '../transactional.dart';

class FetchGroupsStoreLoadingState extends TransactionalState {
  const FetchGroupsStoreLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class FetchGroupsStoreErrorState extends TransactionalState {
  final String message;

  const FetchGroupsStoreErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class FetchGroupsStoreSuccessState extends TransactionalState {
  final List<Group> groups;

  const FetchGroupsStoreSuccessState(this.groups) : super();

  @override
  List<Object?> get props => [groups];
}
