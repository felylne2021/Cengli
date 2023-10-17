import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'bill.g.dart';

@JsonSerializable()
class Bill extends Equatable {
  final String? groupId;

  final String? recipient;

  final String? tokenUnit;

  final String? chain;

  final String? walletAddress;

  final String? date;

  final String? notes;

  final String? status;

  final String? amount;

  const Bill(this.groupId, this.recipient, this.tokenUnit, this.chain,
      this.walletAddress, this.date, this.notes, this.status, this.amount);

  @override
  List<Object?> get props => [
        groupId,
        recipient,
        tokenUnit,
        chain,
        walletAddress,
        date,
        notes,
        status,
        amount
      ];
}
