
class JokeDto {
  bool? error;
  String? category;
  String? type;
  String? setup;
  String? delivery;
  String? joke;
  Flags? flags;
  int? id;
  bool? safe;
  String? lang;

  JokeDto({this.error, this.category, this.type, this.setup, this.delivery, this.joke, this.flags, this.id, this.safe, this.lang});

  JokeDto.fromJson(Map<String, dynamic> json) {
    error = json["error"];
    category = json["category"];
    type = json["type"];
    setup = json["setup"];
    delivery = json["delivery"];
    joke = json["joke"];
    flags = json["flags"] == null ? null : Flags.fromJson(json["flags"]);
    id = json["id"];
    safe = json["safe"];
    lang = json["lang"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["error"] = error;
    _data["category"] = category;
    _data["type"] = type;
    _data["setup"] = setup;
    _data["delivery"] = delivery;
    _data["joke"] = joke;
    if(flags != null) {
      _data["flags"] = flags?.toJson();
    }
    _data["id"] = id;
    _data["safe"] = safe;
    _data["lang"] = lang;
    return _data;
  }
}

class Flags {
  bool? nsfw;
  bool? religious;
  bool? political;
  bool? racist;
  bool? sexist;
  bool? explicit;

  Flags({this.nsfw, this.religious, this.political, this.racist, this.sexist, this.explicit});

  Flags.fromJson(Map<String, dynamic> json) {
    nsfw = json["nsfw"];
    religious = json["religious"];
    political = json["political"];
    racist = json["racist"];
    sexist = json["sexist"];
    explicit = json["explicit"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["nsfw"] = nsfw;
    _data["religious"] = religious;
    _data["political"] = political;
    _data["racist"] = racist;
    _data["sexist"] = sexist;
    _data["explicit"] = explicit;
    return _data;
  }
}