import 'dart:convert';

Cities citiesFromJson(String str) => Cities.fromJson(json.decode(str));

String citiesToJson(Cities data) => json.encode(data.toJson());

class Cities {
  bool error;
  String msg;
  List<String> data;

  Cities({
    required this.error,
    required this.msg,
    required this.data,
  });

  factory Cities.fromJson(Map<String, dynamic> json) => Cities(
    error: json["error"],
    msg: json["msg"],
    data: List<String>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}
