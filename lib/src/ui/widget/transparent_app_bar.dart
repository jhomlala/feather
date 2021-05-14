import 'package:feather/src/data/model/internal/overflow_menu_element.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TransparentAppBar extends StatelessWidget {
  final bool withPopupMenu;
  final Function(PopupMenuElement value)? onPopupMenuClicked;

  const TransparentAppBar(
      {Key? key, this.withPopupMenu = false, this.onPopupMenuClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      //Place it at the top, and not use the entire screen
      top: 0.0,
      left: 0.0,
      right: 0.0,
      child: AppBar(
        actions: <Widget>[
          if (withPopupMenu)
            Theme(
                data: Theme.of(context).copyWith(
                  cardColor: Colors.white,
                ),
                child: PopupMenuButton<PopupMenuElement>(
                  onSelected: (PopupMenuElement element) {
                    if (onPopupMenuClicked != null) {
                      onPopupMenuClicked!(element);
                    }
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  itemBuilder: (BuildContext context) {
                    return _getOverflowMenu(context)
                        .map((PopupMenuElement element) {
                      return PopupMenuItem<PopupMenuElement>(
                        value: element,
                        child: Text(
                          element.title!,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList();
                  },
                ))
        ],
        backgroundColor: Colors.transparent, //No more green
        elevation: 0.0, //Shadow gone
      ),
    );
  }

  List<PopupMenuElement> _getOverflowMenu(BuildContext context) {
    final applicationLocalization = AppLocalizations.of(context)!;
    final List<PopupMenuElement> menuList = [];
    menuList.add(PopupMenuElement(
      key: const Key("menu_overflow_settings"),
      title: applicationLocalization.settings,
    ));
    menuList.add(PopupMenuElement(
      key: const Key("menu_overflow_about"),
      title: applicationLocalization.about,
    ));
    return menuList;
  }
}
