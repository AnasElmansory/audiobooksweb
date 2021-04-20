import 'package:audiobooks/models/user.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class UserWidget extends StatefulWidget {
  final User user;

  const UserWidget({Key key, this.user}) : super(key: key);
  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  User get user => widget.user;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onHover: (isHovered) async {
        if (isHovered)
          await _animationController.animateTo(1);
        else
          await _animationController.animateBack(0.7);
      },
      child: AnimatedContainer(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.25),
        duration: const Duration(milliseconds: 300),
        child: GFListTile(
          titleText: user.username,
          subtitleText: user.isAdmin.toString(),
          icon: const ButtonBar(
            children: [
              const Icon(Icons.delete, color: Colors.red),
              const Icon(Icons.admin_panel_settings, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}
