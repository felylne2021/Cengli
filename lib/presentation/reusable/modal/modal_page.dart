import 'package:cengli/data/modules/transfer/model/response/balance_response.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

import '../../../data/modules/transfer/model/response/chain_response.dart';
import 'component/modal_header.dart';
import 'datepicker/date_picker_component.dart';

class ModalListPage extends StatefulWidget {
  const ModalListPage(
      {super.key,
      required this.argument,
      this.isNetworkImage = false,
      this.chains,
      this.assets});
  final KxListModalArgument argument;
  final List<ChainResponse>? chains;
  final List<BalanceResponse>? assets;
  final bool isNetworkImage;

  @override
  State<ModalListPage> createState() => _ModalListPageState();
}

class _ModalListPageState extends State<ModalListPage> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: KxModalUtil().getHeightModal(widget.argument, context),
          minHeight: MediaQuery.of(context).size.height * 0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            14.0.height,
            ModalHeader(title: widget.argument.modalTitle),
            14.0.height,
            modalBody(widget.argument, widget.chains, widget.assets,
                    widget.isNetworkImage)
                .flexible()
          ],
        ),
      ),
    );
  }

  Widget modalBody(KxListModalArgument argument, List<ChainResponse>? chains,
      List<BalanceResponse>? assets, bool isNetworkImage) {
    Widget result = const SizedBox();
    if (isNetworkImage) {
      if (chains != null) {
        result = chainsListBody(chains);
      } else {
        result = assetsListBody(assets ?? []);
      }
    } else {
      switch (argument.modalListType) {
        case KxModalListType.general:
          result = modalListBody(argument);
          break;

        case KxModalListType.datePicker:
          result = const DatePickerComponent();
          break;
      }
    }
    return result;
  }

  Widget modalListBody(KxListModalArgument argument) {
    return ListView.builder(
      itemCount: argument.items.length,
      itemBuilder: (context, index) {
        return modalListItem(argument, index, context);
      },
    );
  }

  Widget chainsListBody(List<ChainResponse> chains) {
    return ListView.builder(
      itemCount: chains.length,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () => Navigator.of(context).pop(chains[index]),
            child: networkLisItem(chains[index].chainName ?? "",
                chains[index].logoURI ?? "", ""));
      },
    );
  }

  Widget assetsListBody(List<BalanceResponse> assets) {
    return ListView.builder(
      itemCount: assets.length,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () => Navigator.of(context).pop(assets[index]),
            child: networkLisItem(
                assets[index].token?.name ?? "",
                assets[index].token?.logoURI ?? "",
                assets[index].balance.toString()));
      },
    );
  }

  Widget networkLisItem(String title, String imageUrl, String trailing) {
    return Row(
      children: [
        Image.network(imageUrl, width: 40, height: 40),
        16.0.width,
        Text(title,
            style: KxTypography(
                type: KxFontType.body2, color: KxColors.neutral700)),
        const Spacer(),
        Text(trailing,
            style: KxTypography(
                type: KxFontType.buttonMedium, color: KxColors.neutral700)),
      ],
    ).padding(const EdgeInsets.symmetric(vertical: 12));
  }
}
