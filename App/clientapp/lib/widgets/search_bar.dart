import 'package:clientapp/themes/colors.dart';
import 'package:flutter/material.dart';

class Search_Bar extends StatelessWidget {
  final ValueChanged<String> onSearch;

  const Search_Bar({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search events...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white54),
            contentPadding: EdgeInsets.symmetric(vertical: 15.0),
          ),
          style: TextStyle(color: Colors.white),
          onSubmitted: onSearch,
        ),
      ),
    );
  }
}
