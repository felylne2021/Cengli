import 'dart:typed_data';

import 'package:cengli/presentation/chat/group/chat_room/chat_room_provider.dart';
import 'package:cengli/presentation/chat/group/chat_room/chat_room_screen.dart';
import 'package:cengli/presentation/chat/group/conversations/conversations_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});
  static const String routeName = '/conversation_page';

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final vm = ref.watch(conversationsProvider);
          final spaces = vm.conversations;
          if (vm.isBusy && spaces.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 32),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: spaces.length,
            itemBuilder: (context, index) {
              final item = spaces[index];
              final image = item.groupInformation?.groupImage ??
                  item.profilePicture ??
                  '';

              return ListTile(
                onTap: () {
                  ref.read(chatRoomProvider).setCurrentChatId(item.chatId!);
                  Navigator.of(context)
                      .pushNamed(ChatRoomScreen.routeName, arguments: item);
                },
                leading: ProfileImage(imageUrl: image),
                title: Text(
                    '${item.groupInformation?.groupName ?? item.intentSentBy}'),
                subtitle:
                    Text(item.msg?.messageContent ?? 'Send first message'),
              );
            },
          );
        },
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key, required this.imageUrl});
  final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purpleAccent),
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(
          Icons.person,
          color: Colors.purple,
        ),
      );
    }
    try {
      if (imageUrl!.startsWith('https://')) {
        return Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purpleAccent),
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(
                imageUrl!,
              ),
              fit: BoxFit.cover,
            ),
          ),
        );
      }

      final UriData? data = Uri.parse(imageUrl!).data;

      Uint8List myImage = data!.contentAsBytes();

      return Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purpleAccent),
          shape: BoxShape.circle,
          image: DecorationImage(
            image: MemoryImage(
              myImage,
            ),
            fit: BoxFit.cover,
          ),
        ),
      );
    } catch (e) {
      return Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purpleAccent),
          shape: BoxShape.circle,
          color: Colors.purple,
        ),
      );
    }
  }
}
