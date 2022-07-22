import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  const CustomDropdownButton({Key? key}) : super(key: key);

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: const Icon(
          Icons.more_vert_outlined,
          color: Colors.white,
          size: 21,
        ),
        customItemsHeight: 8,
        items: [
          ...MenuItems.firstItems.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          )
        ],
        onChanged: (value) {
          MenuItems.onChanged(context, value as MenuItem);
        },
        itemHeight: 40,
        itemPadding: const EdgeInsets.only(left: 16, right: 16),
        dropdownWidth: 200,
        dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
        dropdownElevation: 8,
        offset: const Offset(-185, -10),
      ),
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [small, tv];
  // static const List<MenuItem> secondItems = [logout];

  static const small =
      MenuItem(text: 'Trình phát thu nhỏ', icon: Icons.featured_video_outlined);
  static const tv =
      MenuItem(text: 'Phát qua TV', icon: Icons.connected_tv_outlined);
  // static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  // static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.small:
        //Do something

        
        break;
      case MenuItems.tv:
        //Do something
        break;
      // case MenuItems.settings:
      //   //Do something
      //   break;
      // case MenuItems.logout:
      //   //Do something
      //   break;
    }
  }
}
