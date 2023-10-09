import 'package:cengli/data/transactional/model/expense.dart';
import '../transactional.dart';

class FetchExpensesStoreLoadingState extends TransactionalState {
  const FetchExpensesStoreLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class FetchExpensesStoreErrorState extends TransactionalState {
  final String message;

  const FetchExpensesStoreErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class FetchExpensesStoreSuccessState extends TransactionalState {
  final List<Expense> expenses;

  const FetchExpensesStoreSuccessState(this.expenses) : super();

  @override
  List<Object?> get props => [expenses];
}
