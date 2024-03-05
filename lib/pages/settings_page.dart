import 'package:flutter/material.dart';

import '../main.dart';
import '../models/settings_model.dart';

class SettingsPage extends StatefulWidget {
  final JokeSettings settings;

  const SettingsPage({Key? key, required this.settings}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late List<String> selectedCategories;
  late List<String> selectedFlags;

  final List<String> availableCategories = [
    'Any', 'Programming', 'Miscellaneous', 'Dark', 'Pun', 'Spooky', 'Christmas'
  ];

  final List<String> availableFlags = [
    'nsfw', 'religious', 'political', 'racist', 'sexist', 'explicit'
  ];

  @override
  void initState() {
    super.initState();
    selectedCategories = widget.settings.categories;
    selectedFlags = widget.settings.blacklistFlags;
  }

  void _handleCategoryChange(bool? value, String category) {
    setState(() {
      if (category == 'Any' && value == true) {
        selectedCategories = ['Any']; // Select only "Any" and remove all others
      } else {
        if (value == true) {
          selectedCategories.remove('Any'); // Remove "Any" if other categories are selected
          selectedCategories.add(category);
        } else {
          selectedCategories.remove(category);
        }
      }
    });
  }

  Widget buildCheckboxListTiles(List<String> options, List<String> selectedOptions, void Function(bool?, String) onChanged) {
    return Column(
      children: options.map((option) => CheckboxListTile(
        title: Text(option),
        value: selectedOptions.contains(option),
        onChanged: (bool? value) {
          onChanged(value, option);
        },
      )).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome! Please select your preferences.')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(
              title: const Text('Select Categories'),
              children: [
                buildCheckboxListTiles(availableCategories, selectedCategories, _handleCategoryChange),
              ],
            ),
            ExpansionTile(
              title: const Text('Select Blacklist Flags'),
              children: [
                buildCheckboxListTiles(availableFlags, selectedFlags, (bool? value, String flag) {
                  setState(() {
                    value == true ? selectedFlags.add(flag) : selectedFlags.remove(flag);
                  });
                }),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                widget.settings.categories = selectedCategories;
                widget.settings.blacklistFlags = selectedFlags;
                // Navigate to JokePage instead of popping back
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JokePage(jokeSettings: widget.settings)));
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
