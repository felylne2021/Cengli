import '../transactional.dart';

class MigrateDataLoadingState extends TransactionalState {
  const MigrateDataLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class MigrateDataErrorState extends TransactionalState {
  final String message;

  const MigrateDataErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class MigrateDataSuccessState extends TransactionalState {
  const MigrateDataSuccessState() : super();

  @override
  List<Object?> get props => [];
}
