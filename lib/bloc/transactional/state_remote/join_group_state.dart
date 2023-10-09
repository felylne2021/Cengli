import '../transactional.dart';

class JoinGroupLoadingState extends TransactionalState {
  const JoinGroupLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class JoinGroupErrorState extends TransactionalState {
  final String message;

  const JoinGroupErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class JoinGroupSuccessState extends TransactionalState {
  const JoinGroupSuccessState() : super();

  @override
  List<Object?> get props => [];
}
