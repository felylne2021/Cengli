
import '../transactional.dart';

class CreateGroupLoadingState extends TransactionalState {
  const CreateGroupLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class CreateGroupErrorState extends TransactionalState {
  final String message;

  const CreateGroupErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class CreateGroupSuccessState extends TransactionalState {

  const CreateGroupSuccessState() : super();

  @override
  List<Object?> get props => [];
}
