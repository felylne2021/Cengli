import 'package:cengli/data/modules/transactional/model/expense.dart';

import '../transactional.dart';

class FetchExpensesLoadingState extends TransactionalState {
  const FetchExpensesLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class FetchExpensesErrorState extends TransactionalState {
  final String message;

  const FetchExpensesErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class FetchExpensesSuccessState extends TransactionalState {
  final List<Expense> expenses;

  const FetchExpensesSuccessState(this.expenses) : super();

  @override
  List<Object?> get props => [expenses];
}
