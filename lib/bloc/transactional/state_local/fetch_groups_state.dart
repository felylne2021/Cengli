import 'package:cengli/data/modules/transactional/model/group.dart';

import '../transactional.dart';

class FetchGroupsLoadingState extends TransactionalState {
  const FetchGroupsLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class FetchGroupsErrorState extends TransactionalState {
  final String message;

  const FetchGroupsErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class FetchGroupsSuccessState extends TransactionalState {
  final List<Group> groups;

  const FetchGroupsSuccessState(this.groups) : super();

  @override
  List<Object?> get props => [groups];
}
