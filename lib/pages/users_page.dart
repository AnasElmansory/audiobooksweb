import 'package:audiobooks/models/user.dart';
import 'package:audiobooks/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage();
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    _handleUsersPagination(_pagingController, context);
    super.initState();
  }

  @override
  void dispose() {
    _pagingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dividerIndent = size.width * 0.25;
    return Scaffold(
      body: PagedListView.separated(
        pagingController: _pagingController,
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
  return GFListTile(
    onTap: () {},
    hoverColor: Colors.blueGrey.shade200,
    titleText: user.username,
    subtitleText: user.isAdmin.toString(),
    icon: const ButtonBar(
      children: [
        const Icon(Icons.delete, color: Colors.red),
        const Icon(Icons.admin_panel_settings, color: Colors.green),
      ],
    ),
  );
}

void _handleUsersPagination(
  PagingController _pagingController,
  BuildContext context,
) async {
  final usersProvider = context.read<UserProvider>();
  _pagingController.itemList = usersProvider.users.toList();
  _pagingController.nextPageKey =
      ((usersProvider.users.length / 10) + 1).floor();
  if (usersProvider.users.isEmpty) {
    final users = await usersProvider.getUsers();
    _pagingController.appendPage(users, 2);
  }
  try {
    _pagingController.addPageRequestListener((pageKey) async {
      final users = await usersProvider.getUsers(page: pageKey);
      final isLastPage = users.length < 10;
      if (isLastPage) {
        _pagingController.appendLastPage(users);
      } else {
        _pagingController.appendPage(users, pageKey + 1);
      }
    });
  } catch (error) {
    _pagingController.error = error;
  }
}
