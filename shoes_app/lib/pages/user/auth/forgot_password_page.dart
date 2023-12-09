import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/theme.dart';

import '../../../providers/auth_provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController emailController;

  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor1,
      ),
      backgroundColor: backgroundColor1,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Kamu Lupa Password ?',
                style: primaryTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Silahkan masukkan email kamu',
                  style: primaryTextStyle,
                ),
              ),
              const SizedBox(
                height: 10,
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
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  onPressed: () async {
                    final result =
                        await authProvider.forgotPassword(emailController.text);
                    if (mounted) {
                      if (result == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: secondaryColor,
                            content: const Text(
                              'Cek Email Anda',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: alertColor,
                            content: const Text(
                              'Gagal Mengirim Ke Email',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    'Request Password Reset',
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
