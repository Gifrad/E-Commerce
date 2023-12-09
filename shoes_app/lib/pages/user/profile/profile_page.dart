import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/models/auth/user_model.dart';
import 'package:shoes_app/providers/auth_provider.dart';
import 'package:shoes_app/providers/transaction_provider.dart';
import 'package:shoes_app/utils/get_token.dart';
import 'package:shoes_app/utils/url.dart';

import '../../../theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    UserModel user = authProvider.user;

    Widget header() {
      return AppBar(
        backgroundColor: backgroundColor3,
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.all(defaultMargin),
            child: Row(
              children: [
                user.photo == basePhotoProfile
                    ? const CircleAvatar(
                        maxRadius: 50,
                        backgroundImage: AssetImage(
                          'assets/image_profile.png',
                        ),
                      )
                    : CircleAvatar(
                        maxRadius: 50,
                        backgroundImage: NetworkImage(
                          '${user.photo}',
                        ),
                      ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hallo ${user.name}',
                        style: primaryTextStyle.copyWith(
                            fontSize: 24, fontWeight: semiBold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${user.email}',
                        style: primaryTextStyle.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    TransactionProvider transactionProvider =
                        Provider.of<TransactionProvider>(context,
                            listen: false);
                    final token = await GetToken.getToken();
                    if (await authProvider.logout(token!)) {
                      transactionProvider.transactions.clear();
                      if (mounted) {}
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/sign-in', (route) => false);
                    } else {
                      if (mounted) {}
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: alertColor,
                          content: const Text(
                            'Logout Failed!',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  },
                  child: Image.asset(
                    'assets/button_exit.png',
                    width: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget menuItem(String text) {
      return Container(
        margin: const EdgeInsets.only(
          top: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: secondaryTextStyle.copyWith(
                fontSize: 13,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: primaryTextColor,
            ),
          ],
        ),
      );
    }

    Widget content() {
      return Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Account',
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/edit-profile', (route) => false);
                  },
                  child: menuItem('Edit Profile')),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/your-orders');
                  },
                  child: menuItem('Your Orders')),
              menuItem('Help'),
              const SizedBox(
                height: 30,
              ),
              Text(
                'General',
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
              menuItem('Privacy & Policy'),
              menuItem('Term of Service'),
              menuItem('Rate App'),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        header(),
        content(),
      ],
    );
  }
}
