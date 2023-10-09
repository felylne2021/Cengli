import 'dart:convert';

import 'package:cengli/bloc/transactional/transactional.dart';
import 'package:cengli/data/transactional/model/group.dart';
import 'package:cengli/presentation/chat/account_provider.dart';
import 'package:cengli/presentation/chat/group/__group.dart';
import 'package:cengli/presentation/chat/signer.dart';
import 'package:cengli/push_protocol/push_restapi_dart.dart';
import 'package:cengli/services/session_service.dart';
import 'package:ethers/signers/wallet.dart' as ethers;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinetix/kinetix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/auth/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  static const String routeName = '/home_page';

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    _checkWallet();
  }

  _checkWallet() async {
    context.read<AuthBloc>().add(const CheckWalletEvent());
  }

  @override
  Widget build(BuildContext context) {
    _createGroupChat();

    return Scaffold(
        appBar: KxAppBarLeftTitle(
          elevationType: KxElevationAppBarEnum.noShadow,
          appBarTitle: "Cengli",
          trailingWidgets: [
            InkWell(
              onTap: () {
                _createGroupChat();
              },
              child: const Icon(
                CupertinoIcons.add,
                color: KxColors.primary600,
              ),
            )
          ],
        ),
        body: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
                child: ElevatedButton(
                    onPressed: () async {
                      final vm = ref.watch(accountProvider);
                      final walletAddress =
                          await SessionService.getWalletAddress();
                      final pgpPrivateKey =
                          await SessionService.getPgpPrivateKey();
                      vm.creatSocketConnection(walletAddress, pgpPrivateKey);
                      if (!mounted) return;
                      Navigator.of(context)
                          .pushNamed(ConversationsScreen.routeName);
                    },
                    child: Text("Test")))));
  }

  void _createGroupChat() async {
    try {
      final walletAddress = await SessionService.getWalletAddress();
      final privateKey = await SessionService.getSignerAddress(walletAddress);

      final group = await createGroup(
          groupName: "New Group",
          signer: EthersSigner(
              ethersWallet: ethers.Wallet.fromPrivateKey(privateKey),
              address: walletAddress),
          groupDescription: "groupDescription",
          members: ["0x84f9B18c02E2169540903da20a96379EF07346dc"],
          admins: ["0x2aD52D59B9e9a43478B3e849e8e0DB3407d64768"],
          isPublic: false);

      debugPrint(group?.chatId.toString());

      //*TODO create firebase group
    } catch (e) {
      debugPrint("duarr $e");
    }
  }

  _createGroupStore(Group group) async {
    context.read<TransactionalBloc>().add(CreateGroupStoreEvent(group));
  }

  _fetchGroupStore(String userId) async {
    context.read<TransactionalBloc>().add(FetchGroupsStoreEvent(userId));
  }
}
