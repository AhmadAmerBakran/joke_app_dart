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
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.amber,
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.blueGrey[900]),
            bodyMedium: TextStyle(color: Colors.blueGrey[900]),
            titleLarge: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueGrey,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Jokes"),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToSettings(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (joke != null)
              SvgPicture.network(
                "https://api.dicebear.com/7.x/adventurer/svg?seed=${joke?.id}",
                placeholderBuilder: (
                    BuildContext context) => const CircularProgressIndicator(),
                width: 150,
                height: 150,
              ),
            if (joke == null)
              const CircularProgressIndicator(),
            if (joke?.joke != null)
              ChatBubble(text: joke!.joke!),
            if (joke?.setup != null)
              ChatBubble(text: joke!.setup!),
            if (joke?.delivery != null)
              ChatBubble(text: joke!.delivery!),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadJoke,
        child: Icon(Icons.refresh),
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .secondary,
      ),
    );
  }
}


  class ChatBubble extends StatelessWidget {
  final String text;
  const ChatBubble({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}
