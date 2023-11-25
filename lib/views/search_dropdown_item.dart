import 'package:flutter/material.dart';

const List<String> list = <String>['Name', 'Ingredient'];

class DropdownButtonSearchFilter extends StatefulWidget {
  final Function(String) onFilterChanged;
  const DropdownButtonSearchFilter({super.key, required this.onFilterChanged});

  @override
  State<DropdownButtonSearchFilter> createState() => _DropdownButtonSearchFilterState();
}

class _DropdownButtonSearchFilterState extends State<DropdownButtonSearchFilter> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      elevation: 16,
      icon: const Icon(Icons.arrow_downward),
      isExpanded: true,
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
        widget.onFilterChanged(dropdownValue); // Pass the selected filter mode
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}