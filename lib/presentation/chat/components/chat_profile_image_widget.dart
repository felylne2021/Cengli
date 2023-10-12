import 'dart:typed_data';
import 'package:flutter/material.dart';

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
          color: Colors.purple,
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
        decoration: BoxDecoration(
          border: Border.all(color: primaryGreen600),
          shape: BoxShape.circle,
          color: primaryGreen600,
        ),
      );
    }
  }
}
