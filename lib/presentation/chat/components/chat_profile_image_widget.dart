import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../values/values.dart';

class ProfileProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final bool isP2p;

  const ProfileProfileImageWidget(
      {super.key, required this.imageUrl, this.isP2p = false});

  @override
  Widget build(BuildContext context) {
    if (isP2p) {
      return Container(
          height: 64,
          width: 64,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: softPurple,
          ),
          child: SvgPicture.asset(IC_P2P));
    } else {
      if (imageUrl == null) {
        return Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              border: Border.all(color: primaryGreen600),
              shape: BoxShape.circle,
            ),
            child: Image.asset(IMG_GROUP));
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
          ),
          child: Image.asset(IMG_GROUP),
        );
      }
    }
  }
}
