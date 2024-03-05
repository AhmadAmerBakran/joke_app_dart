import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'data_source.dart';
import 'joke_dto.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => DataSource(),
      child: MaterialApp(
        title: 'Joke App',
        home: JokePage(),
      ),
    );
  }
}


class JokePage extends StatefulWidget {
  const JokePage({super.key});

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
    setState(() {
      joke = null;
    });
    final newJoke = await context.read<DataSource>().getJoke();
    setState(() {
      joke = newJoke;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jokes")),
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