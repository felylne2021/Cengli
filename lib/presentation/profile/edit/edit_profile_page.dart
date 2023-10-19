import 'dart:convert';
import 'dart:io';

import 'package:cengli/bloc/auth/auth.dart';
import 'package:cengli/bloc/auth/state/get_user_state.dart';
import 'package:cengli/bloc/membership/state/update_username_state.dart';
import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kinetix/kinetix.dart';

import '../../../bloc/membership/membership.dart';
import '../../../utils/utils.dart';
import '../../../values/values.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});
  static const String routeName = '/edit_profile_page';
  final UserProfile user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  ValueNotifier<bool> isValid = ValueNotifier(false);
  ValueNotifier<String> errorMessage = ValueNotifier("");
  String imageProfile = '';
  File? _image;
  final _picker = ImagePicker();
  String image64 = "";
  String formattedImage64 = "";
  @override
  void initState() {
    super.initState();
    fullnameController.text = widget.user.name ?? "";
    userNameController.text = widget.user.userName ?? "";
    imageProfile = widget.user.imageProfile ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarWithBackButton(
        appbarTitle: 'Edit Profile',
        trailingWidgets: [
          ValueListenableBuilder(
              valueListenable: isValid,
              builder: (context, value, child) {
                return SizedBox(
                  width: 53,
                  child: KxTextButton(
                      isDisabled: !value,
                      argument: KxTextButtonArgument(
                          onPressed: () => isValid.value ? _save() : null,
                          buttonTextStyle: KxTypography(
                              type: KxFontType.buttonSmall,
                              color: value
                                  ? KxColors.neutral700
                                  : KxColors.neutral500),
                          buttonSize: KxButtonSizeEnum.small,
                          buttonType: KxButtonTypeEnum.primary,
                          buttonShape: KxButtonShapeEnum.round,
                          buttonContent: KxButtonContentEnum.text,
                          buttonText: 'Save',
                          buttonColor: primaryGreen600,
                          textColor: KxColors.neutral700)),
                );
              })
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, state) {
              return state is CheckUsernameSuccessState ||
                  state is CheckUsernameLoadingState ||
                  state is CheckUsernameErrorState;
            },
            listener: ((context, state) {
              if (state is CheckUsernameSuccessState) {
                hideLoading();
                if (state.isExist) {
                  errorMessage.value = "This username is taken";
                  validate();
                } else {
                  errorMessage.value = "";
                  validate();
                }
              } else if (state is CheckUsernameLoadingState) {
                showLoading();
              } else if (state is CheckUsernameErrorState) {
                showToast(state.message);
                hideLoading();
              }
            }),
          ),
          BlocListener<MembershipBloc, MembershipState>(
            listenWhen: (previous, state) {
              return state is UpdateUserNameErrorState ||
                  state is UpdateUserNameSuccessState;
            },
            listener: (context, state) {
              if (state is UpdateUserNameSuccessState) {
                SessionService.setUsername(userNameController.text);
                context
                    .read<AuthBloc>()
                    .add(GetUserDataEvent(userNameController.text));
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, state) {
              return state is GetUserDataSuccessState ||
                  state is GetUserDataErrorState;
            },
            listener: (context, state) {
              if (state is GetUserDataSuccessState) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
        child: _profileBody(),
      ),
    );
  }

  SingleChildScrollView _profileBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              if (imageProfile.isNotEmpty)
                Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Image.network(
                      imageProfile,
                      fit: BoxFit.cover,
                    ))
              else
                Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                      color: KxColors.neutral200, shape: BoxShape.circle),
                  child: const Icon(
                    CupertinoIcons.person_fill,
                    color: KxColors.neutral400,
                  ),
                ),
              Positioned(
                right: 0,
                bottom: 0,
                child: InkWell(
                  //TODO: finish
                  // onTap: _openImagePicker,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: primaryGreen600,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "Change",
                      style: KxTypography(
                          type: KxFontType.caption3,
                          color: KxColors.neutral700),
                    ),
                  ),
                ),
              )
            ],
          ),
          24.0.height,
          _profileTextField(
              'Fullname', fullnameController, false, errorMessage),
          16.0.height,
          _profileTextField('Username', userNameController, true, errorMessage)
        ],
      ).padding().center(),
    );
  }

  Widget _profileTextField(String title, TextEditingController controller,
      bool check, ValueNotifier<String> errorMessage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: KxTypography(
              type: KxFontType.caption2, color: KxColors.neutral700),
        ),
        ValueListenableBuilder(
            valueListenable: errorMessage,
            builder: (context, message, child) {
              return KxFilledTextField(
                errorMessage: check
                    ? message.isEmpty
                        ? null
                        : message
                    : null,
                controller: controller,
                suffix: !check
                    ? const SizedBox()
                    : InkWell(
                        onTap: () => _checkUsername(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                              color: primaryGreen600,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text("Check",
                              style: KxTypography(
                                  type: KxFontType.buttonMedium,
                                  color: KxColors.neutral700)),
                        )),
              );
            }),
      ],
    );
  }

  _checkUsername() {
    context.read<AuthBloc>().add(CheckUsernameEvent(userNameController.text));
  }

  _save() {
    context.read<MembershipBloc>().add(UpdateUserNameEvent(
        fullnameController.text,
        userNameController.text,
        widget.user.id ?? ""));
  }

  validate() {
    isValid.value =
        fullnameController.text.isNotEmpty && errorMessage.value.isEmpty;
  }

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        final imageBytes = File(pickedImage.path).readAsBytesSync();
        image64 = base64Encode(imageBytes);
        formattedImage64 = "data:image/png;base64,$image64}";
        // _uploadAvatar(UploadAvatarRequest(photo: formattedImage64));
      });
    }
  }
}
