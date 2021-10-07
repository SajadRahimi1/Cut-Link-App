// To parse this JSON data, do
//
//     final zaya = zayaFromJson(jsonString);

import 'dart:convert';

Zaya zayaFromJson(String str) => Zaya.fromJson(json.decode(str));

class Zaya {
  Zaya({
    required this.data,
  });

  Data data;

  factory Zaya.fromJson(Map<String, dynamic> json) => Zaya(
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    required this.shortUrl,
  });

  String shortUrl;
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        shortUrl: json["short_url"],
      );
}
