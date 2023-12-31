import '../../../data/modules/transactional/model/group.dart';
import '../transactional.dart';

class CreateGroupStoreLoadingState extends TransactionalState {
  const CreateGroupStoreLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class CreateGroupStoreErrorState extends TransactionalState {
  final String message;

  const CreateGroupStoreErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class CreateGroupStoreSuccessState extends TransactionalState {
  final Group group;
  
  const CreateGroupStoreSuccessState(this.group) : super();

  @override
  List<Object?> get props => [group];
}
