import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

import '../../../values/values.dart';

class ProfileProfileImageWidget extends StatelessWidget {
  final String? imageUrl;

  const ProfileProfileImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          border: Border.all(color: primaryGreen600),
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: const Icon(
          Icons.person,
          color: KxColors.neutral200,
        ),
      );
    }
    try {
      if (imageUrl!.startsWith('https://')) {
        return Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            border: Border.all(color: primaryGreen600),
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
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          border: Border.all(color: primaryGreen600),
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
        height: 64,
        width: 64,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: KxColors.neutral200,
        ),
        child: const Icon(
          CupertinoIcons.person_2_fill,
          color: KxColors.neutral400,
        ),
      );
    }
  }
}
