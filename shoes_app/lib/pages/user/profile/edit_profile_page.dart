import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/pages/main_page.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/get_token.dart';
import 'package:shoes_app/utils/url.dart';

import '../../../models/auth/user_model.dart';
import '../../../providers/auth_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      imageQuality: 50,
      source: ImageSource.gallery,
    );

    setState(() {
      _imageFile = File(image!.path);
    });
    if (mounted) {}
    Navigator.pop(context);
  }

  Future<void> cameraImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );

    setState(() {
      _imageFile = File(image!.path);
    });
    if (mounted) {}
    Navigator.pop(context);
  }

  @override
  void initState() {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    UserModel? user = authProvider.user;
    nameController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    nameController.text = user.name!;
    usernameController.text = user.username!;
    emailController.text = user.email!;
    user.phone != null
        ? phoneController.text = user.phone!
        : phoneController.text = '0';
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    header() {
      return AppBar(
        backgroundColor: backgroundColor3,
        elevation: 0,
        centerTitle: true,
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainPage(),
                ),
                (route) => false);
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final token = await GetToken.getToken();
              if (_imageFile == null) {
                final result = await authProvider.update(
                  nameController.text,
                  usernameController.text,
                  emailController.text,
                  phoneController.text,
                  token!,
                );
                if (_formKey.currentState!.validate()) {
                  if (result == true) {
                    if (mounted) {}
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                        (route) => false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: secondaryColor,
                        content: const Text(
                          'Success Updated!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    if (mounted) {}
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: alertColor,
                        content: const Text(
                          'Failed Updated!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                }
              } else {
                final result = await authProvider.updateImage(
                  nameController.text,
                  usernameController.text,
                  emailController.text,
                  phoneController.text,
                  token!,
                  _imageFile,
                );
                if (_formKey.currentState!.validate()) {
                  if (result == true) {
                    if (mounted) {}
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                        (route) => false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: secondaryColor,
                        content: const Text(
                          'Success Updated Image!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    if (mounted) {}
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: alertColor,
                        content: const Text(
                          'Failed Updated Image!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                }
              }
            },
            icon: Icon(
              Icons.check,
              color: primaryColor,
            ),
          )
        ],
      );
    }

    Widget nameInput() {
      return Container(
        margin: EdgeInsets.only(top: defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: secondaryTextStyle.copyWith(
                fontSize: 13,
              ),
            ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "Tidak boleh kosong";
                }
                return null;
              },
              controller: nameController,
              style: primaryTextStyle,
              decoration: InputDecoration(
                // hintText: '${user.name}',
                // hintStyle: subtitleTextStyle,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: blackColor,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget usernameInput() {
      return Container(
        margin: EdgeInsets.only(top: defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username',
              style: secondaryTextStyle.copyWith(
                fontSize: 13,
              ),
            ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "Tidak boleh kosong";
                }
                return null;
              },
              controller: usernameController,
              style: primaryTextStyle,
              decoration: InputDecoration(
                // hintText: '${user.username}',
                // hintStyle: subtitleTextStyle,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: blackColor,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget emailInput() {
      return Container(
        margin: EdgeInsets.only(top: defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email Address',
              style: secondaryTextStyle.copyWith(
                fontSize: 13,
              ),
            ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "Tidak boleh kosong";
                }
                return null;
              },
              controller: emailController,
              style: primaryTextStyle,
              decoration: InputDecoration(
                // hintText: '${user.email}',
                // hintStyle: subtitleTextStyle,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: blackColor,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget phoneInput() {
      return Container(
        margin: EdgeInsets.only(top: defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phone Number',
              style: secondaryTextStyle.copyWith(
                fontSize: 13,
              ),
            ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "Tidak boleh kosong";
                }
                return null;
              },
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: phoneController,
              style: primaryTextStyle,
              decoration: InputDecoration(
                // hintText: '${user.email}',
                // hintStyle: subtitleTextStyle,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: blackColor,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget content() {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  Center(
                    child: _imageFile == null &&
                            authProvider.user.photo == basePhotoProfile
                        ? Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: defaultMargin),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage('assets/image_profile.png'),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextButton(
                                              onPressed: cameraImage,
                                              child: const Text('Camera')),
                                          TextButton(
                                              onPressed: pickImage,
                                              child: const Text('Gallery'))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.photo_camera,
                                  size: 24,
                                  color: secondaryTextColor,
                                ),
                              ),
                            ),
                          )
                        : authProvider.user.photo == basePhotoProfile
                            ? Container(
                                width: 120.0,
                                height: 120.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: FileImage(_imageFile!),
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextButton(
                                                  onPressed: cameraImage,
                                                  child: const Text('Camera')),
                                              TextButton(
                                                  onPressed: pickImage,
                                                  child: const Text('Gallery'))
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.photo_camera,
                                      size: 24,
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                ),
                              )
                            : _imageFile != null
                                ? Container(
                                    width: 120.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: FileImage(_imageFile!),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextButton(
                                                      onPressed: cameraImage,
                                                      child:
                                                          const Text('Camera')),
                                                  TextButton(
                                                      onPressed: pickImage,
                                                      child:
                                                          const Text('Gallery'))
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.photo_camera,
                                          size: 24,
                                          color: secondaryTextColor,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 120.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            '${authProvider.user.photo}'),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextButton(
                                                      onPressed: cameraImage,
                                                      child:
                                                          const Text('Camera')),
                                                  TextButton(
                                                      onPressed: pickImage,
                                                      child:
                                                          const Text('Gallery'))
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.photo_camera,
                                          size: 24,
                                          color: secondaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                  ),
                ],
              ),
              nameInput(),
              usernameInput(),
              emailInput(),
              phoneInput(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor1,
      appBar: header(),
      body: content(),
    );
  }
}
