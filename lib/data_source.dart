import 'dart:convert';
import 'package:http/http.dart' as http;

import 'joke_dto.dart';
import 'models/settings_model.dart';

class DataSource {
  final JokeSettings settings;

  DataSource({required this.settings});

  Future<JokeDto> getJoke() async {
    String baseUrl = "https://v2.jokeapi.dev/joke/";
    String categories = settings.categoriesAsString;
    String flags = settings.blacklistFlagsAsString;
    String url = "$baseUrl$categories${flags.isNotEmpty ? '?$flags' : ''}";

    final response = await http.get(Uri.parse(url));
    final map = json.decode(response.body);
    return JokeDto.fromJson(map);
  }
}