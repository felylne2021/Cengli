import 'package:cengli/data/modules/transactional/model/participant.dart';
import '../transactional.dart';

class FetchParticipantsLoadingState extends TransactionalState {
  const FetchParticipantsLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class FetchParticipantsErrorState extends TransactionalState {
  final String message;

  const FetchParticipantsErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class FetchParticipantsSuccessState extends TransactionalState {
  final List<Participant> participants;

  const FetchParticipantsSuccessState(this.participants) : super();

  @override
  List<Object?> get props => [participants];
}
