import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'bill.g.dart';

@JsonSerializable()
class Bill extends Equatable {
  final String? groupName;

  final String? recipient;

  final String? tokenUnit;

  final String? chain;

  final String? walletAddress;

  final String? date;

  final String? notes;

  final String? status;

  final String? amount;

  const Bill(this.groupName, this.recipient, this.tokenUnit, this.chain,
      this.walletAddress, this.date, this.notes, this.status, this.amount);

  @override
  List<Object?> get props => [
        groupName,
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
