import 'package:flutter/material.dart';

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
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(
              title: const Text('Select Categories'),
              children: [
                buildCheckboxListTiles(availableCategories, selectedCategories, (bool? value, String category) {
                  setState(() {
                    value == true ? selectedCategories.add(category) : selectedCategories.remove(category);
                  });
                }),
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
                Navigator.pop(context, widget.settings); // Return updated settings
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
