enum CollectionEnum { groups, participants, expenses, users, orders }

enum UserRoleEnum { user, partner }

enum GroupTypeEnum { general, p2p }

enum OrderStatusEnum {
  ordered,
  waiting,
  paid,
  completed;

  String label() {
    switch (this) {
      case OrderStatusEnum.ordered:
        return "New Order";
      case OrderStatusEnum.waiting:
        return "Waiting for payments";
      case OrderStatusEnum.paid:
        return "Paid";
      case OrderStatusEnum.completed:
        return "Completed";
    }
  }
}
