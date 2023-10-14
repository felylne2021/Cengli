import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

import 'component/modal_header.dart';

class ModalListPage extends StatefulWidget {
  const ModalListPage({super.key, required this.argument});
  final KxListModalArgument argument;

  @override
  State<ModalListPage> createState() => _ModalListPageState();
}

class _ModalListPageState extends State<ModalListPage> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          minHeight: MediaQuery.of(context).size.height * 0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            14.0.height,
            ModalHeader(title: widget.argument.modalTitle),
            14.0.height,
            modalBody(widget.argument).flexible()
          ],
        ),
      ),
    );
  }

  Widget modalBody(KxListModalArgument argument) {
    Widget result = const SizedBox();
    switch (argument.modalListType) {
      case KxModalListType.general:
        result = modalListBody(argument);
        break;
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
}
