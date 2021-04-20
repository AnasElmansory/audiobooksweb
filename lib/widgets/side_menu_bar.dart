import 'package:audiobooks/models/menu.dart';
import 'package:audiobooks/pages/sign_page.dart';
import 'package:audiobooks/providers/page_view_provider.dart';
import 'package:audiobooks/providers/user_provider.dart';
import 'package:audiobooks/utils/theme.dart';
import 'package:audiobooks/widgets/menu_item.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideBarMenu extends StatefulWidget {
  const SideBarMenu();
  @override
  _SideBarMenuState createState() => _SideBarMenuState();
}

class _SideBarMenuState extends State<SideBarMenu>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final pageProvider = context.watch<PageViewProvider>();
    final userNameIsEmail =
        userProvider.user?.email == userProvider.user?.username;
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          const BoxShadow(
            blurRadius: 10,
            color: Colors.black26,
            spreadRadius: 2,
          )
        ],
        color: drawerBgColor,
      ),
      child: (size.height < 400)
          ? const SizedBox()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Colors.blueGrey.shade200),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI4JuatGP6M5_Q0wYSkx2jAVzJff1FBaPYXV7zFbMngh5RV6J7'),
                    ),
                    accountName: AutoSizeText(
                      '${userNameIsEmail ? '' : userProvider.user?.username ?? ""}',
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    accountEmail: AutoSizeText(
                      '${userProvider.user?.email ?? ""}',
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  flex: 3,
                  child: ListView.separated(
                    separatorBuilder: (context, counter) =>
                        const Divider(height: 2),
                    itemCount: menuItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: MenuItemTile(
                          title: menuItems[index].title,
                          icon: menuItems[index].icon,
                          animationController: _animationController,
                          isSelected: pageProvider.page == index,
                          onTap: () async => await pageProvider.toPage(index),
                        ),
                      );
                    },
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await userProvider.signOut();
                    final signRoute = MaterialPageRoute(
                      builder: (_) => const SignPage(),
                    );
                    await Navigator.of(context).pushReplacement(signRoute);
                  },
                  child: const Icon(
                    Icons.power_settings_new,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
    );
  }
}

Widget _responsiveView(Size size) {
  final width = size.width;
  if (width < (width / 3)) {}
}
