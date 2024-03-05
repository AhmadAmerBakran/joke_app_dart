import 'dart:convert';
import 'package:http/http.dart' as http;

import 'joke_dto.dart';

class DataSource {
  Future<JokeDto> getJoke() async {
    // Your URL from goes here...
    const url = "https://v2.jokeapi.dev/joke/Programming?blacklistFlags=nsfw,religious,political,racist,sexist,explicit";
    final response = await http.get(Uri.parse(url));
    final map = json.decode(response.body);
    return JokeDto.fromJson(map);
  }
}