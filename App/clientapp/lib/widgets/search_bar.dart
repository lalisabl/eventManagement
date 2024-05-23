import 'package:flutter/material.dart';

class Search_Bar extends StatelessWidget {
  final ValueChanged<String> onSearch;

  const Search_Bar({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search events...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white54),
        ),
        style: TextStyle(color: Colors.white),
        onSubmitted: onSearch,
      ),
    );
  }
}
