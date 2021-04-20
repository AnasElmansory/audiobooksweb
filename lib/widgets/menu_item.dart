import 'package:audiobooks/utils/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MenuItemTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final AnimationController animationController;
  final bool isSelected;
  final Function onTap;

  const MenuItemTile({
    Key key,
    @required this.title,
    @required this.icon,
    this.animationController,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  _MenuItemTileState createState() => _MenuItemTileState();
}

class _MenuItemTileState extends State<MenuItemTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.isSelected
              ? Colors.transparent.withOpacity(0.3)
              : Colors.transparent,
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        // width: _animation.value,
        margin: EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Icon(
                widget.icon,
                color: widget.isSelected ? selectedColor : Colors.white30,
                size: 38,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: AutoSizeText(
                widget.title,
                maxLines: 2,
                style: widget.isSelected
                    ? menuListTileSelectedText
                    : menuListTileDefaultText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
