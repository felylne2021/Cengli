import 'package:cengli/bloc/membership/membership.dart';
import 'package:cengli/presentation/p2p/components/p2p_item_widget.dart';
import 'package:cengli/presentation/p2p/p2p_request_page.dart';
import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/values/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinetix/kinetix.dart';

class P2pPage extends StatefulWidget {
  const P2pPage({super.key});
  static const String routeName = '/p2p_page';

  @override
  State<P2pPage> createState() => _P2pPageState();
}

class _P2pPageState extends State<P2pPage> {
  @override
  void initState() {
    super.initState();
    _fetchPartners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbarWithBackButton(appbarTitle: 'P2P'),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(5, 12, 12, 12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: primaryGreen100,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Image.asset(
                      IMG_TOPUP,
                      width: 83,
                      height: 83,
                    ),
                    10.0.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Turn cash into crypto instantly",
                          style: KxTypography(
                              type: KxFontType.subtitle4,
                              color: KxColors.neutral700),
                        ),
                        8.0.height,
                        Text(
                          "Easily Transform your physical cash into digital currency through Cengli Partners",
                          style: KxTypography(
                              type: KxFontType.caption4,
                              color: KxColors.neutral600),
                        ),
                      ],
                    ).flexible()
                  ],
                )),
            BlocBuilder<MembershipBloc, MembershipState>(
              buildWhen: (previous, state) {
                return state is FetchP2pSuccessState ||
                    state is FetchP2pLoadingState ||
                    state is FetchP2pErrorState;
              },
              builder: (context, state) {
                debugPrint(state.toString());
                if (state is FetchP2pSuccessState) {
                  debugPrint(state.partners.toString());
                  return Column(
                      children: List.generate(
                          state.partners.length,
                          (index) => InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(P2pRequestPage.routeName),
                              child: P2pItemWidget(
                                name: state.partners[index].userName ?? "",
                                quantity: "1.062, 00 USDC",
                                method: state.partners[index].p2pMethod ?? "",
                              ))));
                } else {
                  return const CupertinoActivityIndicator()
                      .padding(const EdgeInsets.only(top: 40));
                }
              },
            )
          ],
        )));
  }

  _fetchPartners() {
    context.read<MembershipBloc>().add(const FetchP2pEvent());
  }
}
