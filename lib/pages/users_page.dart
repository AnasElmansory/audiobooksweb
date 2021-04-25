import 'package:audiobooks/models/user.dart';
import 'package:audiobooks/providers/user_provider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage();
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    _handleUsersPagination();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = context.watch<UserProvider>();
    final size = MediaQuery.of(context).size;
    final dividerIndent = size.width * 0.25;
    return Scaffold(
      body: PagedListView.separated(
        pagingController: usersProvider.controller,
        separatorBuilder: (context, index) => Divider(
          indent: dividerIndent,
          endIndent: dividerIndent,
          height: 0,
        ),
        builderDelegate: PagedChildBuilderDelegate<User>(
          itemBuilder: (context, user, index) {
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                child: _userWidget(user));
          },
        ),
      ),
    );
  }
}

Widget _userWidget(User user) {
  final userProvider = Get.context.watch<UserProvider>();
  final currentUser = userProvider.user;
  return GFListTile(
    titleText: user.username,
    subtitleText: user.isAdmin ? 'Admin' : 'User',
    avatar: CircularProfileAvatar(
      user?.avatar ?? '',
      errorWidget: (context, url, error) => const Image(
        image: const AssetImage('asset/images/user_placeholder.png'),
      ),
      initialsText: Text('${user.username.capitalizeFirst[0]}'),
      backgroundColor: Colors.blueGrey,
    ),
    icon: (currentUser.isAdmin)
        ? ButtonBar(
            children: [
              if(!user.isAdmin)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await userProvider.deleteUser(user.id);
                },
              ),
              if (!user.isAdmin)
                IconButton(
                  icon: const Icon(Icons.admin_panel_settings,
                      color: Colors.green,),
                  onPressed: () async {
                    await userProvider.grantAdmin(user.id);
                  },
                )
            ],
          )
        : Container(),
  );
}

void _handleUsersPagination() async {
  final usersProvider = Get.context.read<UserProvider>();
  final controller = usersProvider.controller;
  try {
    controller.addPageRequestListener((pageKey) async {
      final reviews = await usersProvider.getUsers(page: pageKey);
      final isLastPage = reviews.length < 10;
      if (isLastPage) {
        controller.appendLastPage(reviews);
      } else {
        controller.appendPage(reviews, pageKey + 1);
      }
    });
  } catch (error) {
    controller.error = error;
  }
}
