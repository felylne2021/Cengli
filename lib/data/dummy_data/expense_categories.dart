import 'package:cengli/values/values.dart';

class Categories {
  final String name;
  final String iconPath;

  Categories(this.name, this.iconPath);
}

List<Categories> categories = [
  Categories('Food & beverage', IC_CAT_FOOD),
  Categories('Entertainment', IC_CAT_ENT),
  Categories('Groceries', IC_CAT_GROCERIES),
  Categories('Housing bills', IC_CAT_HOUSE),
  Categories('Transportation', IC_CAT_TRANSPORT),
  Categories('Other Expense', IC_CAT_OTHER),
];
