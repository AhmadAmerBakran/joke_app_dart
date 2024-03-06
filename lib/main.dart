import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
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

  const JokePage({Key? key, required this.jokeSettings}) : super(key: key);

  @override
  State<JokePage> createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {
  int _sliderValue = 5;
  double _speechRate = 0.5;
  List<Map<String, dynamic>> _voices = [];
  String? _selectedVoice;
  JokeDto? joke;
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _loadJoke();
    _initializeTts();
    _initVoices();
  }

  void _initVoices() async {
    var voices = await flutterTts.getVoices;
    setState(() {
      _voices = voices.map<Map<String, dynamic>>((voice) => Map<String, dynamic>.from(voice)).toList();
      if (_voices.isNotEmpty) {
        _selectedVoice = _voices.first['name'];
      }
    });
  }


  void _initializeTts() {
    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
      });
    });
    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
      });
    });
    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
      });
    });

    flutterTts.setLanguage("en-US");
  }

  Future<void> _speak() async {
    String textToSpeak = '';

    if (joke?.setup != null && joke?.delivery != null) {
      textToSpeak = "${joke!.setup} ... ${joke!.delivery}";
    }
    else if (joke?.joke != null) {
      textToSpeak = joke!.joke!;
    }

    if (textToSpeak.isNotEmpty) {
      await flutterTts.speak(textToSpeak);
    }
  }

  Future<void> _pause() async {
    await flutterTts.pause();
  }

  Future<void> _stop() async {
    await flutterTts.stop();
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
            if (joke?.joke != null) ChatBubble(text: joke!.joke!),
            if (joke?.setup != null) ChatBubble(text: joke!.setup!),
            if (joke?.delivery != null) ChatBubble(text: joke!.delivery!),
            if (joke == null)
              const CircularProgressIndicator(),
            if (joke?.joke != null || joke?.setup != null || joke?.delivery != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: _speak,
                      child: Text('Speak'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _pause,
                      child: Text('Pause'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _stop,
                      child: Text('Stop'),
                    ),
                  ],
                ),
              ),
            Slider(
              value: _sliderValue.toDouble(),
              onChanged: (newValue) {
                setState(() {
                  _sliderValue = newValue.round();
                  double speechRate = _sliderValue / 10;
                  flutterTts.setSpeechRate(speechRate);
                });
              },
              min: 1,
              max: 10,
              divisions: 9,
              label: "$_sliderValue",
            ),
            DropdownButton<String>(
              value: _selectedVoice,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedVoice = newValue;
                    flutterTts.setVoice({"name": newValue, "locale": _voices.firstWhere((voice) => voice['name'] == newValue)['locale']});
                  });
                }
              },
              items: _voices.map<DropdownMenuItem<String>>((Map<String, dynamic> voice) {
                return DropdownMenuItem<String>(
                  value: voice['name'],
                  child: Text(voice['name']),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadJoke,
        child: Icon(Icons.refresh),
        backgroundColor: Theme.of(context).colorScheme.secondary,
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
