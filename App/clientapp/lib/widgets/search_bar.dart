import 'package:clientapp/themes/colors.dart';
import 'package:flutter/material.dart';

class Search_Bar extends StatelessWidget {
  final ValueChanged<String> onSearch;

  const Search_Bar({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.light;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.secondaryColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search events...',
            hintStyle:
                TextStyle(color: !isDarkMode ? Colors.white54 : Colors.black54),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: !isDarkMode ? Colors.white54 : Colors.black54),
            contentPadding: EdgeInsets.symmetric(vertical: 15.0),
          ),
          style: TextStyle(color: !isDarkMode ? Colors.white54 : Colors.black54),
          onSubmitted: onSearch,
        ),
      ),
    );
  }
}
