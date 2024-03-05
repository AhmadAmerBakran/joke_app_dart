import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:make_me_laugh/pages/settings_page.dart';
import 'package:provider/provider.dart';

import 'data_source.dart';
import 'joke_dto.dart';
import 'models/settings_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final jokeSettings = JokeSettings();

    return Provider<DataSource>(
      create: (context) => DataSource(settings: jokeSettings),
      child: MaterialApp(
        title: 'Joke App',
        home: SettingsPage(settings: jokeSettings),
      ),
    );
  }
}


class JokePage extends StatefulWidget {
  final JokeSettings jokeSettings;

  const JokePage({super.key, required this.jokeSettings});

  @override
  State<JokePage> createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {
  JokeDto? joke;

  @override
  void initState() {
    super.initState();
    _loadJoke();
  }

  _loadJoke() async {
    final newJoke = await context.read<DataSource>().getJoke();
    setState(() {
      joke = newJoke;
    });
  }
  void _navigateToSettings() async {
    final updatedSettings = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(settings: widget.jokeSettings),
      ),
    );

    if (updatedSettings != null) {
      setState(() {
        widget.jokeSettings.categories = updatedSettings.categories;
        widget.jokeSettings.blacklistFlags = updatedSettings.blacklistFlags;
      });
      _loadJoke();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jokes"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _navigateToSettings(),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (joke != null)
            SvgPicture.network(
              "https://api.dicebear.com/7.x/lorelei-neutral/svg?seed=${joke?.id}",
              placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
              width: 100,
              height: 100,
            ),
          if (joke == null)
            const CircularProgressIndicator(),
          if (joke?.joke != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(joke!.joke!),
            ),
          if (joke?.setup != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(joke!.setup!),
            ),
          if (joke?.delivery != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(joke!.delivery!),
            ),
          TextButton(onPressed: _loadJoke, child: const Text("Show another")),
        ],
      ),
    );
  }
}