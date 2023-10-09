import '../transactional.dart';

class CreateExpenseStoreLoadingState extends TransactionalState {
  const CreateExpenseStoreLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class CreateExpenseStoreErrorState extends TransactionalState {
  final String message;

  const CreateExpenseStoreErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class CreateExpenseStoreSuccessState extends TransactionalState {
  const CreateExpenseStoreSuccessState() : super();

  @override
  List<Object?> get props => [];
}
