import '../transactional.dart';

class CreateExpenseLoadingState extends TransactionalState {
  const CreateExpenseLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class CreateExpenseErrorState extends TransactionalState {
  final String message;

  const CreateExpenseErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class CreateExpenseSuccessState extends TransactionalState {
  const CreateExpenseSuccessState() : super();

  @override
  List<Object?> get props => [];
}
