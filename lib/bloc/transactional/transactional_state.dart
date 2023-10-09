import 'package:velix/velix.dart';

abstract class TransactionalState extends BaseState {
  const TransactionalState() : super();
}

class TransactionalInitiateState extends TransactionalState {
  const TransactionalInitiateState() : super();

  @override
  List<Object?> get props => [];
}
