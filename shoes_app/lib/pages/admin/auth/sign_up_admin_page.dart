import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/pages/widgets/loading_button.dart';
import 'package:shoes_app/providers/auth_provider.dart';
import 'package:shoes_app/theme.dart';

class SignUpAdminPage extends StatefulWidget {
  const SignUpAdminPage({super.key});

  @override
  State<SignUpAdminPage> createState() => _SignUpAdminPageState();
}

class _SignUpAdminPageState extends State<SignUpAdminPage> {
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    nameController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    void handleSignUp() async {
      setState(() {
        isLoading = true;
      });

      final result = await authProvider.register(
        nameController.text,
        usernameController.text,
        emailController.text,
        'ADMIN',
        passwordController.text,
      );
      if (result == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: secondaryColor,
              content: const Text(
                'Berhasil Mendaftar',
                textAlign: TextAlign.center,
              ),
            ),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/sign-in',
            (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: alertColor,
              content: const Text(
                'Gagal Register!',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      }
      setState(() {
        isLoading = false;
      });
    }

    Widget header() {
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign Up',
              style: primaryTextStyle.copyWith(
                fontWeight: semiBold,
                fontSize: 24,
              ),
            ),
            Text(
              'Register and Manage Order',
              style: primaryTextStyle,
            )
          ],
        ),
      );
    }

    Widget nameInput() {
      return Container(
        margin: const EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Full Name',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: textFieldBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icon_name.png',
                      width: 17,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: nameController,
                        style: blackTextStyle,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Your Full Name',
                          hintStyle: subtitleTextStyle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget userNameInput() {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: textFieldBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icon_username.png',
                      width: 17,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: usernameController,
                        style: blackTextStyle,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Your Username',
                          hintStyle: subtitleTextStyle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget emailInput() {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email Address',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: textFieldBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icon_email.png',
                      width: 17,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: emailController,
                        style: blackTextStyle,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Your Email Address',
                          hintStyle: subtitleTextStyle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget passwordInput() {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: textFieldBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icon_password.png',
                      width: 17,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Consumer<AuthProvider>(
                        builder: (context, value, child) => TextFormField(
                          controller: passwordController,
                          obscureText: value.isTrue,
                          style: blackTextStyle,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                value.toggleObs();
                              },
                              icon: value.switchObsIcon,
                            ),
                            hintText: 'Your Password',
                            hintStyle: subtitleTextStyle,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget signUpButton() {
      return Container(
        height: 50,
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              )),
          onPressed: handleSignUp,
          child: Text(
            'Sign Up',
            style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
          ),
        ),
      );
    }

    Widget footer() {
      return Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style:
                  primaryTextStyle.copyWith(fontSize: 12, fontWeight: reguler),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                'Sign In',
                style: purpleTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: bold,
                ),
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: defaultMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(),
              nameInput(),
              userNameInput(),
              emailInput(),
              passwordInput(),
              isLoading ? const LoadingButton() : signUpButton(),
              const Spacer(),
              footer(),
            ],
          ),
        ),
      ),
    );
  }
}
