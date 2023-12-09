import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/providers/auth_provider.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/url.dart';

import '../../../utils/get_token.dart';

class CustomerAdminPage extends StatefulWidget {
  const CustomerAdminPage({super.key});

  @override
  State<CustomerAdminPage> createState() => _CustomerAdminPageState();
}

class _CustomerAdminPageState extends State<CustomerAdminPage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of(context, listen: false);
    TextEditingController searchController = TextEditingController();

    PreferredSizeWidget header() {
      return AppBar(
        centerTitle: true,
        title: const Text('Customers'),
        elevation: 0,
        backgroundColor: bgColorAdmin1,
      );
    }

    Widget body() {
      return Consumer<AuthProvider>(
        builder: (context, value, child) => Container(
          margin: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 8),
          child: Column(
            children: [
              TextField(
                onChanged: (text) async {
                  value.changeSearchString(searchController.text.toLowerCase());
                },
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              value.userRoles.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          'Not Found...',
                          style: blackTextStyle.copyWith(
                              fontSize: 22, fontWeight: semiBold),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: value.userRoles.length,
                        itemBuilder: (context, index) {
                          final users = value.userRoles.elementAt(index);
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            elevation: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: bgColorAdmin2,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                    maxRadius: 30,
                                    backgroundImage: NetworkImage(users.photo !=
                                            basePhotoProfile
                                        ? '${users.photo}'
                                        : 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png')),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'id : ${users.id}',
                                      style: primaryTextStyle,
                                    ),
                                    Text(
                                      '${users.name}',
                                      style: primaryTextStyle.copyWith(
                                        fontSize: 20,
                                        fontWeight: semiBold,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${users.username}',
                                      style: primaryTextStyle,
                                    ),
                                    Text(
                                      '${users.email}',
                                      style: primaryTextStyle,
                                    ),
                                    users.phone != null
                                        ? Text(
                                            '${users.phone}',
                                            style: primaryTextStyle,
                                          )
                                        : const SizedBox.shrink()
                                  ],
                                ),
                                trailing: IconButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          backgroundColor: primaryTextColor,
                                          content: const Text(
                                              'Are you sure delete this customer?'),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        secondaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    final token = await GetToken
                                                        .getToken();
                                                    final result =
                                                        await value.delete(
                                                            users.id!, token!);
                                                    if (result) {
                                                      await value
                                                          .getRolesUser(token);
                                                      if (mounted) {}
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          backgroundColor:
                                                              secondaryColor,
                                                          content: const Text(
                                                            'Success Delete User',
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      );
                                                      Navigator.pop(context);
                                                    } else {
                                                      if (mounted) {}
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          backgroundColor:
                                                              alertColor,
                                                          content: const Text(
                                                            'Failed Delete Photo',
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      );
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: alertColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('No'),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete_forever,
                                      size: 32,
                                      color: alertColor,
                                    )),
                              ),
                            ),
                          );
                        },
                      ),
                    )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColorAdmin3,
      appBar: header(),
      body: authProvider.userRoles.isEmpty
          ? Center(
              child: Text(
                'Not Found...',
                style: blackTextStyle.copyWith(
                  fontSize: 22,
                  fontWeight: bold,
                ),
              ),
            )
          : body(),
    );
  }
}
