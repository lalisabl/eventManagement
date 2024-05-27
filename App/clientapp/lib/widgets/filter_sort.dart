import 'package:flutter/material.dart';

class FilterSort extends StatelessWidget {
  final String locationFilter;
  final ValueChanged<String> onSort;
  final ValueChanged<String> onFilter;

  const FilterSort({
    Key? key,
    required this.locationFilter,
    required this.onSort,
    required this.onFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> locations = ['Addis Ababa', 'Adama', 'Dire Dawa', 'Ambo', 'Jimma', 'Hawasa'];

    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.sort, color: Colors.white),
          onPressed: () async {
            final sort = await showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: Text('Sort by'),
                  children: <Widget>[
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, 'date'),
                      child: Text('Date'),
                    ),
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, 'price'),
                      child: Text('Price'),
                    ),
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, 'availability'),
                      child: Text('Availability'),
                    ),
                  ],
                );
              },
            );
            if (sort != null) {
              onSort(sort);
            }
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: locations.map((location) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(location),
                    selected: locationFilter == location,
                    onSelected: (bool selected) {
                      onFilter(selected ? location : '');
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
