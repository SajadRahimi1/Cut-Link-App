// To parse this JSON data, do
//
//     final g02 = g02FromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

G02 g02FromJson(String str) => G02.fromJson(json.decode(str));

class G02 {
  G02({
    required this.fullShortLink,
  });
  String fullShortLink;

  factory G02.fromJson(Map<String, dynamic> json) => G02(
        fullShortLink: json["full_short_link"],
      );
}
