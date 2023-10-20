import 'package:cengli/bloc/transfer/transfer.dart';
import 'package:cengli/services/push_protocol/src/models/src/requests_model.dart';

import '../../../data/modules/transactional/model/group.dart';

class CreateGroupP2pLoadingState extends TransferState {
  const CreateGroupP2pLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class CreateGroupP2pErrorState extends TransferState {
  final String message;

  const CreateGroupP2pErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class CreateGroupP2pSuccessState extends TransferState {
  final Group group;
  final Feeds feeds;

  const CreateGroupP2pSuccessState(this.feeds, this.group) : super();

  @override
  List<Object?> get props => [feeds, group];
}
