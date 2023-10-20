import 'package:cengli/bloc/auth/auth.dart';
import 'package:cengli/bloc/auth/state/get_user_state.dart';
import 'package:cengli/bloc/transactional/transactional.dart';
import 'package:cengli/data/dummy_data/expense_categories.dart';
import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/data/modules/transactional/model/expense.dart';
import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/presentation/reusable/checkbox/general_checkbox.dart';
import 'package:cengli/presentation/reusable/modal/modal_page.dart';
import 'package:cengli/services/session_service.dart';
import 'package:cengli/values/styles.dart';
import 'package:cengli/values/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kinetix/kinetix.dart';

import '../../../bloc/membership/membership.dart';
import '../../../data/modules/transactional/model/charges.dart';
import '../../../utils/utils.dart';
import '../../reusable/notifier/double_notifier.dart';
import '../../reusable/textfield/textfield_widget.dart';
import 'component/expense_component.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key, required this.chatId});

  final String chatId;
  static const String routeName = '/add_expense_page';

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String groupId = '';
  ValueNotifier<KxSelectedListItem> selectedCategory = ValueNotifier(
      KxSelectedListItem('Category', false, imagePath: IC_CATEGORY_LOGO));
  ValueNotifier<String> username = ValueNotifier('');
  ValueNotifier<String> date = ValueNotifier('');
  ValueNotifier<KxSelectedListItem> selectedPerson =
      ValueNotifier(KxSelectedListItem('Select who paid', true));
  ValueNotifier<List<UserProfile>> members = ValueNotifier([]);
  ValueNotifier<List<UserProfile>> temporaryMembers = ValueNotifier([]);

  ValueNotifier<List<KxSelectedListItem>> formattedMembers = ValueNotifier([]);
  ValueNotifier<List<KxSelectedListItem>> formattedCategories =
      ValueNotifier([]);
  ValueNotifier<List<KxSelectedListItem>> chargedMembers = ValueNotifier([]);
  ValueNotifier<double> amount = ValueNotifier(0);
  ValueNotifier<bool> selected = ValueNotifier(false);
  ValueNotifier<UserProfile> userData = ValueNotifier(UserProfile());
  ValueNotifier<int> totalMembers = ValueNotifier(1);
  String name = '';
  @override
  void initState() {
    super.initState();
    _initiateData();
  }

  _initiateData() async {
    name = await SessionService.getUsername().then((value) {
      selectedPerson.value.title = value;
      return value;
    });
    username.value = '$name (You)';
    date.value = getCurrentDate();
    _getUserData(name);
    members.value.clear();
    formattedMembers.value.clear();
    formattedCategories.value.clear();
    chargedMembers.value.clear();
    temporaryMembers.value.clear();
  }

  _saveExpense(Expense expense, List<Charges> charges) async {
    context
        .read<TransactionalBloc>()
        .add(CreateExpenseStoreEvent(expense, charges));
  }

  _getUserData(String name) {
    context.read<AuthBloc>().add(GetUserDataEvent(name));
    context.read<MembershipBloc>().add(GetGroupEvent(widget.chatId));
  }

  _insertData() {
    for (var member in members.value) {
      KxSelectedListItem item =
          KxSelectedListItem(member.name ?? "Default name", true);
      formattedMembers.value.add(item);
    }
    chargedMembers.value = formattedMembers.value;
    temporaryMembers.value = members.value;

    for (var category in categories) {
      KxSelectedListItem item = KxSelectedListItem(category.name, false,
          imagePath: category.iconPath);
      formattedCategories.value.add(item);
    }
  }

  String _findMemberId(String name) {
    String id = '';
    for (UserProfile member in members.value) {
      if (name == member.userName) {
        id = member.id ?? "";
      }
    }
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbarBackAndCenter(
            appbarTitle: 'Add Expense',
            trailingWidgets: [
              SizedBox(
                width: 53,
                child: ValueListenableBuilder(
                    valueListenable: formattedMembers,
                    builder: (context, members, child) {
                      return KxTextButton(
                          argument: KxTextButtonArgument(
                              onPressed: () {
                                String memberPayId =
                                    _findMemberId(selectedPerson.value.title);

                                final filteredChargedMembers = (chargedMembers
                                    .value
                                    .where((members) => members.selected));

                                List<Charges> charges = filteredChargedMembers
                                    .map((member) => Charges(
                                        userId: _findMemberId(member.title),
                                        count: 1,
                                        status: 'not paid',
                                        price: amount.value /
                                            filteredChargedMembers.length))
                                    .toList();

                                Expense finalExpense = Expense(
                                    groupId: groupId,
                                    amount: amountController.text,
                                    category: selectedCategory.value.title,
                                    date: date.value,
                                    memberPayId: memberPayId,
                                    tokenUnit: 'USDC',
                                    title: titleController.text
                                    // membersCharged:
                                    );

                                if (amountController.text.isNotEmpty &&
                                    titleController.text.isNotEmpty) {
                                  _saveExpense(finalExpense, charges);
                                } else {
                                  showToast(
                                      'Title Expense or Amount must be inputted');
                                }
                              },
                              buttonSize: KxButtonSizeEnum.small,
                              buttonType: KxButtonTypeEnum.primary,
                              buttonShape: KxButtonShapeEnum.round,
                              buttonContent: KxButtonContentEnum.text,
                              buttonText: 'Save',
                              buttonColor: primaryGreen600,
                              textColor: KxColors.neutral700));
                    }),
              )
            ]),
        body: MultiBlocListener(
            listeners: [
              BlocListener<MembershipBloc, MembershipState>(
                  listenWhen: (previous, state) {
                return state is GetGroupLoadingState ||
                    state is GetGroupSuccessState ||
                    state is GetGroupErrorState;
              }, listener: ((context, state) {
                if (state is GetGroupSuccessState) {
                  groupId = state.group.id ?? "";
                  _getMembers(state.group.members ?? []);
                } else if (state is GetGroupErrorState) {}
              })),
              BlocListener<AuthBloc, AuthState>(listenWhen: (previous, state) {
                return state is GetUserDataLoadingState ||
                    state is GetUserDataSuccessState ||
                    state is GetUserDataErrorState;
              }, listener: (previous, state) {
                if (state is GetUserDataSuccessState) {
                  userData.value = state.user;
                  selectedPerson.value = KxSelectedListItem(
                      state.user.name ?? "No name", true,
                      imagePath: state.user.imageProfile ?? "");
                } else if (state is GetUserDataErrorState) {
                  showToast(state.error);
                }
              }),
              BlocListener<TransactionalBloc, TransactionalState>(
                listenWhen: (previous, state) {
                  return state is CreateExpenseStoreLoadingState ||
                      state is CreateExpenseStoreSuccessState ||
                      state is CreateExpenseStoreErrorState;
                },
                listener: (previous, state) async {
                  if (state is CreateExpenseStoreSuccessState) {
                    await _getExpense().then((value) {
                      members.value.clear();
                      Navigator.of(context).pop();
                    });
                  }
                },
              )
            ],
            child: BlocBuilder<MembershipBloc, MembershipState>(
              buildWhen: (previous, state) {
                return state is GetMembersInfoLoadingState ||
                    state is GetMembersInfoSuccessState ||
                    state is GetMembersInfoErrorState;
              },
              builder: (context, state) {
                if (state is GetMembersInfoSuccessState) {
                  members.value.clear();
                  members.value.addAll(state.membersInfo);
                  _insertData();
                  return addExpenseBody(context, members.value);
                } else {
                  return const Center(child: CupertinoActivityIndicator());
                }
              },
            )));
  }

  SingleChildScrollView addExpenseBody(
      BuildContext context, List<UserProfile> members) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            8.0.height,
            // *Upper Section
            Column(
              children: [
                TextField(
                    controller: titleController,
                    cursorHeight: 20,
                    cursorColor: KxColors.primary600,
                    textAlign: TextAlign.center,
                    style: CengliTypography(
                        type: CengliFontType.subtitle2,
                        color: KxColors.neutral700),
                    decoration: InputDecoration.collapsed(
                        hintText: "Title",
                        hintStyle: CengliTypography(
                            type: CengliFontType.subtitle2,
                            color: KxColors.neutral500))),
                38.0.height,
                ValueListenableBuilder(
                    valueListenable: selectedCategory,
                    builder: (context, category, child) {
                      return TextButton(
                              style: KxButtonStyles(
                                  textColor: KxColors.neutral700,
                                  bgColor: primaryGreen600,
                                  onTapColor: primaryGreen600,
                                  buttonPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 7),
                                  borderColor: primaryGreen600,
                                  buttonShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () {
                                KxGeneralListModalArgument argument =
                                    KxGeneralListModalArgument(
                                  modalTitle: 'Category',
                                  items: formattedCategories.value,
                                  selectedItem: selectedCategory.value,
                                  modalListType: KxModalListType.general,
                                );
                                KxModalUtil()
                                    .showGeneralModal(context,
                                        ModalListPage(argument: argument))
                                    .then(
                                  (value) {
                                    if (value != null) {
                                      selectedCategory.value = value;
                                    }
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    category.imagePath,
                                    height: 18,
                                    width: 18,
                                  ),
                                  4.0.width,
                                  Text(
                                    category.title,
                                    style: KxTypography(
                                        type: KxFontType.buttonSmall,
                                        color: KxColors.neutral700),
                                  )
                                ],
                              ))
                          .padding(EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.25));
                    }),
                12.0.height,
                const Divider(
                  thickness: 4,
                  color: KxColors.neutral100,
                ),
              ],
            ).center(),

            // *Lower Section
            Text(
              'Who paid',
              style: KxTypography(
                  type: KxFontType.caption2, color: KxColors.neutral700),
            ),
            8.0.height,

            InkWell(
              onTap: () {
                KxGeneralListModalArgument argument =
                    KxGeneralListModalArgument(
                  modalTitle: 'Who Paid',
                  items: formattedMembers.value,
                  selectedItem: selectedPerson.value,
                  modalListType: KxModalListType.general,
                );
                KxModalUtil()
                    .showGeneralModal(
                        context, ModalListPage(argument: argument))
                    .then(
                  (value) {
                    if (value != null) {
                      selectedPerson.value = value;
                    }
                  },
                );
              },
              child: ValueListenableBuilder(
                  valueListenable: selectedPerson,
                  builder: (context, person, child) {
                    return SizedBox(
                      height: 75,
                      child: ItemSelectionWidget(
                        title: person.title == name
                            ? "${person.title} (You)"
                            : person.title,
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: person.imagePath.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  color: KxColors.neutral500,
                                  size: 40,
                                )
                              : Image.network(person.imagePath),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: KxColors.neutral700,
                        ),
                      ),
                    );
                  }),
            ),
            16.0.height,

            Text(
              'Date',
              style: KxTypography(
                  type: KxFontType.caption2, color: KxColors.neutral700),
            ),
            8.0.height,
            InkWell(
              onTap: () {
                KxDateTimePickerModalArgument argument =
                    KxDateTimePickerModalArgument(
                  modalTitle: 'Date',
                  modalListType: KxModalListType.datePicker,
                );

                KxModalUtil()
                    .showGeneralModal(
                        context, ModalListPage(argument: argument))
                    .then((value) {
                  if (value != null) {
                    KxDatePickerArgument selectedDate = value;
                    date.value = selectedDate.birthdate;
                  }
                });
              },
              child: ValueListenableBuilder(
                  valueListenable: date,
                  builder: (context, d, child) {
                    return ItemSelectionWidget(
                      title: d,
                      trailing: const Icon(
                        Icons.calendar_month_rounded,
                        color: KxColors.neutral700,
                      ),
                    );
                  }),
            ),
            16.0.height,

            Text(
              'Amount',
              style: KxTypography(
                  type: KxFontType.caption2, color: KxColors.neutral700),
            ),
            8.0.height,
            FilledTextFieldWidget(
              controller: amountController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  amount.value = double.parse(value);
                } else {
                  amount.value = 0;
                }
              },
              prefix: Text(
                'USDC',
                style: KxTypography(
                    type: KxFontType.fieldText2, color: KxColors.neutral500),
              ).padding(),
              hint: '00,00',
            ),
            23.0.height,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Charge to',
                  style: KxTypography(
                      type: KxFontType.caption2, color: KxColors.neutral700),
                ),
              ],
            ),
            16.0.height,
            SizedBox(
              height: (MediaQuery.of(context).size.height * 0.4),
              child: ListView.separated(
                  itemBuilder: (cxt, index) {
                    final member = temporaryMembers.value[index];
                    totalMembers.value = temporaryMembers.value.length;

                    return ValueListenableBuilder(
                        valueListenable: temporaryMembers,
                        // second: trackSelected,
                        builder: (context, m, child) {
                          return GeneralCheckbox(
                              initialValue: true,
                              onChanged: (value) {
                                _setSelectedMember(index);

                                if (chargedMembers.value[index].selected ==
                                    false) {
                                  totalMembers.value -= 1;
                                } else {
                                  totalMembers.value >=
                                          temporaryMembers.value.length
                                      ? temporaryMembers.value.length
                                      : totalMembers.value += 1;
                                }
                              },
                              shape: const CircleBorder(),
                              checkboxWidget: Row(
                                children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: member.imageProfile == null
                                          ? const Icon(
                                              Icons.person,
                                              color: KxColors.neutral500,
                                              size: 40,
                                            )
                                          : Image.network(
                                              member.imageProfile ?? "")),
                                  16.0.width,
                                  Text(
                                    member.name ?? "Default name",
                                    style: KxTypography(
                                        type: KxFontType.body1,
                                        color: KxColors.neutral700),
                                  ),
                                  const Spacer(),
                                  DoubleValueListenableBuilder(
                                      first: amount,
                                      second: totalMembers,
                                      builder: (context, money, total, child) {
                                        return Text(
                                          chargedMembers
                                                      .value[index].selected ==
                                                  false
                                              ? '\$0.00'
                                              : '\$${(money / totalMembers.value).toStringAsFixed(2)}',
                                          style: KxTypography(
                                              type: KxFontType.buttonMedium,
                                              color: KxColors.neutral700),
                                        );
                                      })
                                ],
                              ));
                        });
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      thickness: 1,
                      color: KxColors.neutral100,
                    );
                  },
                  itemCount: temporaryMembers.value.length),
            )
          ],
        ),
      ),
    );
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime(now.year, now.month, now.day);
    String currentDateText = DateFormat(FORMAT_DATE).format(currentDate);
    return currentDateText;
  }

  Future<void> _getExpense() async {
    context.read<TransactionalBloc>().add(FetchExpensesStoreEvent(groupId));
  }

  _getMembers(List<String> ids) {
    context.read<MembershipBloc>().add(GetMembersEvent(ids));
  }

  _setSelectedMember(int index) {
    chargedMembers.value[index].selected =
        !chargedMembers.value[index].selected;
  }
}
