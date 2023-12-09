import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/pages/user/auth/forgot_password_page.dart';
import 'package:shoes_app/pages/widgets/loading_button.dart';
import 'package:shoes_app/providers/auth_provider.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/get_roles.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    void handleSignIn() async {
      setState(() {
        isLoading = true;
      });

      final result = await authProvider.login(
        emailController.text,
        passwordController.text,
      );

      if (result == true) {
        final roles = await GetRoles.getRoles();
        if (roles == "USER") {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: secondaryColor,
                content: const Text(
                  'Login as USER',
                  textAlign: TextAlign.center,
                ),
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            );
          }
        } else if (roles == 'ADMIN') {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: secondaryColor,
                content: const Text(
                  'Login as ADMIN',
                  textAlign: TextAlign.center,
                ),
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home-admin',
              (route) => false,
            );
          }
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
                'Gagal Login!',
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
              'Login',
              style: primaryTextStyle.copyWith(
                fontWeight: semiBold,
                fontSize: 24,
              ),
            ),
            Text(
              'Sign In To Continue',
              style: primaryTextStyle,
            )
          ],
        ),
      );
    }

    Widget emailInput() {
      return Container(
        margin: const EdgeInsets.only(top: 70),
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

    Widget forgotPassword() {
      return TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ForgotPassword(),
            ),
          );
        },
        child: Align(
          alignment: Alignment.topRight,
          child: Text(
            'Lupa Password?',
            style: primaryTextStyle,
          ),
        ),
      );
    }

    Widget signInButton() {
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
          onPressed: handleSignIn,
          child: Text(
            'Sign In',
            style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
          ),
        ),
      );
    }

    Widget footer() {
      return Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have an account? ',
              style:
                  primaryTextStyle.copyWith(fontSize: 12, fontWeight: semiBold),
            ),
            const SizedBox(
              height: 38,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/sign-up-admin');
                  },
                  child: Text(
                    'Sign Up as Admin',
                    style: purpleTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/sign-up');
                  },
                  child: Text(
                    'Sign Up as User',
                    style: purpleTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: bold,
                    ),
                  ),
                ),
              ],
            ),
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
              emailInput(),
              passwordInput(),
              forgotPassword(),
              isLoading ? const LoadingButton() : signInButton(),
              const Spacer(),
              footer(),
            ],
          ),
        ),
      ),
    );
  }
}
