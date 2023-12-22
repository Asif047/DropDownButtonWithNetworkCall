import 'dart:convert';

Countries countriesFromJson(String str) => Countries.fromJson(json.decode(str));

String countriesToJson(Countries data) => json.encode(data.toJson());

class Countries {
  bool error;
  String msg;
  List<Datum> data;

  Countries({
    required this.error,
    required this.msg,
    required this.data,
  });

  factory Countries.fromJson(Map<String, dynamic> json) => Countries(
    error: json["error"],
    msg: json["msg"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String iso2;
  String iso3;
  String country;
  List<String> cities;

  Datum({
    required this.iso2,
    required this.iso3,
    required this.country,
    required this.cities,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    iso2: json["iso2"],
    iso3: json["iso3"],
    country: json["country"],
    cities: List<String>.from(json["cities"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "iso2": iso2,
    "iso3": iso3,
    "country": country,
    "cities": List<dynamic>.from(cities.map((x) => x)),
  };
}
