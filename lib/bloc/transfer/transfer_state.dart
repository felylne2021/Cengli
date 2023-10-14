import 'package:velix/velix.dart';

abstract class TransferState extends BaseState {
  const TransferState() : super();
}

class TransferInitiateState extends TransferState {
  const TransferInitiateState() : super();

  @override
  List<Object?> get props => [];
}
