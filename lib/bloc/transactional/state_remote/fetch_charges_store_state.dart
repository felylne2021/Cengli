import '../../../data/modules/transactional/model/charges.dart';
import '../transactional.dart';

class FetchChargesStoreLoadingState extends TransactionalState {
  const FetchChargesStoreLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class FetchChargesStoreErrorState extends TransactionalState {
  final String message;

  const FetchChargesStoreErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class FetchChargesStoreSuccessState extends TransactionalState {
  final Map<String, dynamic> charges;

  const FetchChargesStoreSuccessState(this.charges) : super();

  @override
  List<Object?> get props => [charges];
}
