import 'package:cengli/bloc/transactional/transactional.dart';
import 'package:cengli/data/dummy_data/asset/asset_dummy_data.dart';
import 'package:cengli/data/dummy_data/network/network_dummy_data.dart';
import 'package:cengli/data/dummy_data/transaction/transaction_dummy_data.dart';
import 'package:cengli/data/modules/transactional/model/expense.dart';
import 'package:cengli/presentation/chat/chat_page.dart';
import 'package:cengli/presentation/home/component/bills/bills_page.dart';
import 'package:cengli/presentation/reusable/notifier/double_notifier.dart';
import 'package:cengli/services/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kinetix/kinetix.dart';

import '../../bloc/auth/auth.dart';
import '../../values/values.dart';
import '../reusable/modal/modal_page.dart';
import '../reusable/segmented_control/segmented_control.dart';
import 'component/actions_widget.dart';
import 'component/card_widget.dart';
import 'component/request/request_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routeName = '/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _insertData();
    _getWalletAddress();
    //TODO: unhide once transaction is confirmed from API
    // _getExpenses();
  }

  ValueNotifier<KxSelectedListItem> selectedAssetItem = ValueNotifier(
      KxSelectedListItem(chains[0].title, false, imagePath: IC_POLYGON));
  List<String> segmentedTitles = ['Assets', 'Transactions'];
  List<KxSelectedListItem> assetItems = [];
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  ValueNotifier<String> walletAddress = ValueNotifier('');
  ValueNotifier<List<Expense>> expenseResponse = ValueNotifier([]);

  _checkWallet() async {
    context.read<AuthBloc>().add(const CheckWalletEvent());
  }

  _getWalletAddress() async {
    walletAddress.value = await SessionService.getWalletAddress();
  }

  _getExpenses() async {
    // TODO: refactor dyanmic group ID
    context.read<TransactionalBloc>().add(
        const FetchExpensesStoreEvent("983abe5e-078d-4a82-8f14-cd88997992e1"));
  }

  _insertData() {
    for (var c in chains) {
      KxSelectedListItem item =
          KxSelectedListItem(c.title, false, imagePath: c.image);
      assetItems.add(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: KxColors.neutral50,
        appBar: homePageAppBar(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ValueListenableBuilder(
                    valueListenable: walletAddress,
                    builder: (context, address, child) {
                      return CardWidget(
                        walletAddress: address,
                        balance: 1245,
                        tokenCount: 3,
                      );
                    }),
                24.0.height,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 31),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //TODO: FILL ONTAP ACTION
                      ActionWidget(
                          title: 'Send',
                          bgColor: softGreen,
                          iconPath: IC_SEND,
                          onTap: () {}),
                      ActionWidget(
                          title: 'Request',
                          bgColor: softPurple,
                          iconPath: IC_REQUEST,
                          onTap: () => Navigator.of(context)
                              .pushNamed(RequestPage.routeName)),
                      ActionWidget(
                          title: 'Bills',
                          bgColor: softBlue,
                          iconPath: IC_BILLS,
                          onTap: () => Navigator.of(context)
                              .pushNamed(BillsPage.routeName)),
                    ],
                  ),
                ),
                30.0.height,
                SegmentedControl(
                  activeColor: primaryGreen600,
                  onSelected: (index) {
                    currentIndex.value = index;
                  },
                  title: segmentedTitles,
                  initialIndex: currentIndex.value,
                  segmentType: SegmentedControlEnum.ghost,
                  padding: 50,
                ),
                14.0.height,
                //TODO: refactor once transaction is confirmed in API
                DoubleValueListenableBuilder(
                  first: currentIndex,
                  second: expenseResponse,
                  builder: (context, currIndex, expense, child) {
                    return Column(
                        children: List.generate(
                            currIndex == 1 ? expenses.length : assets.length,
                            (index) {
                      if (currIndex == 1) {
                        final exp = expenses[index];
                        return Column(
                          children: [
                            HomeItemsWidget(
                                title: exp.title ?? "Default Expense Title",
                                subtitle: exp.date ?? "9 Oct 2023, 17:45PM",
                                value: exp.amount ?? "0.0 Rp"),
                            const Divider(
                              thickness: 1,
                              color: KxColors.neutral200,
                            )
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            HomeItemsWidget(
                                title:
                                    assets[index].assetType ?? "Default Type",
                                subtitle:
                                    "${assets[index].count} ${assets[index].unit}",

                                //TODO: unhide once svg ready
                                // imagePath:
                                //     assets[index].imagePath ?? IC_ETHEREUM,
                                value: "\$${assets[index].value}"),
                            const Divider(
                              thickness: 1,
                              color: KxColors.neutral200,
                            )
                          ],
                        );
                      }
                    }));
                  },
                ),
              ],
            ),
          ),
        ));
  }

  PreferredSize homePageAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(84),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SafeArea(
              child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Wallet",
                          style: KxTypography(
                              type: KxFontType.subtitle4,
                              color: KxColors.neutral700)),
                      InkWell(
                        onTap: () {
                          KxGeneralListModalArgument argument =
                              KxGeneralListModalArgument(
                            modalTitle: 'Select Network',
                            items: assetItems,
                            selectedItem: selectedAssetItem.value,
                            modalListType: KxModalListType.general,
                          );
                          KxModalUtil()
                              .showGeneralModal(
                                  context, ModalListPage(argument: argument))
                              .then((value) {
                            if (value != null) {
                              selectedAssetItem.value = value;
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: KxColors.neutral200,
                              borderRadius: BorderRadius.circular(20)),
                          child: ValueListenableBuilder(
                              valueListenable: selectedAssetItem,
                              builder: (context, item, child) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SvgPicture.asset(
                                      item.imagePath,
                                      height: 24,
                                      width: 24,
                                    ),
                                    8.0.width,
                                    Text(
                                      item.title,
                                      style: KxTypography(
                                          type: KxFontType.fieldText2,
                                          color: KxColors.neutral700),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 16,
                                      color: KxColors.neutral700,
                                    )
                                  ],
                                );
                              }),
                        ),
                      )
                    ],
                  ).padding(const EdgeInsets.fromLTRB(16, 30, 16, 12)))),
        ],
      ),
    );
  }

  _navigateToConversation() async {
    // final vm = ref.watch(accountProvider);
    // final walletAddress = await SessionService.getWalletAddress();
    // final pgpPrivateKey = await SessionService.getPgpPrivateKey();
    // vm.creatSocketConnection(walletAddress, pgpPrivateKey);
    if (!mounted) return;
    Navigator.of(context).pushNamed(ChatPage.routeName);
  }
}

class HomeItemsWidget extends StatelessWidget {
  const HomeItemsWidget(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.value,
      this.imagePath = IC_ETHEREUM});
  final String title;
  final String subtitle;
  final String value;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            imagePath,
            height: 40,
            width: 40,
          ),
          16.0.width,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: KxTypography(
                        type: KxFontType.body2, color: KxColors.neutral700),
                  ),
                  Text(
                    subtitle,
                    style: KxTypography(
                        type: KxFontType.fieldText3,
                        color: KxColors.neutral500),
                  )
                ],
              ),
              Text(
                value,
                style: KxTypography(
                    type: KxFontType.buttonMedium, color: deepGreen),
              )
            ],
          ).flexible(),
        ],
      ),
    );
  }
}
