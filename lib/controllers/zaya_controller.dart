import 'dart:io';

import 'package:get/get.dart';
import 'package:short_link_app/controllers/g02_controller.dart';
import 'package:short_link_app/models/zaya_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RequestController {
  var zaya = Zaya(data: Data(shortUrl: "")).obs;
  var g02 = G02(fullShortLink: "").obs;

  void zayaRequest(String url) async {
    zaya.value = await getZayaData(url);
  }

  void g02Request(String url) async {
    g02.value = await getG02Data(url);
  }

  Future<Zaya> getZayaData(String url) async {
    try {
      Get.snackbar("", "",
          icon: Icon(Icons.link),
          showProgressIndicator: true,
          titleText: Text(
            "عملیات",
            textAlign: TextAlign.right,
          ),
          messageText:
              Text("در حال کوتاه کردن لینک", textAlign: TextAlign.right));
      var respone =
          await http.post(Uri.parse("https://zaya.io/api/v1/links"), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization':
            'Bearer 80PoHzx2u0TtA2tfrrkZ3Ko4wn6p8cAlJccxs2HfECaRtFTYxbPrft1zcEwx',
      }, body: {
        'url': '$url'
      });
      return zayaFromJson(respone.body);
    } on SocketException {
      Get.snackbar("", "",
          titleText: Text(
            "اینترنت",
            textAlign: TextAlign.right,
          ),
          messageText: Text("اینترنت تلفن شما خاموش می باشد",
              textAlign: TextAlign.right));
      print("d");
    } catch (e) {
      Get.snackbar("", "",
          titleText: Text(
            "خطا",
            textAlign: TextAlign.right,
          ),
          messageText:
              Text("در ارتباط خطایی رخ داد", textAlign: TextAlign.right));
      print("c");
    }
    return Zaya(data: Data(shortUrl: ""));
  }

  Future<G02> getG02Data(String inputUrl) async {
    try {
      Get.snackbar("", "",
          icon: Icon(Icons.link),
          showProgressIndicator: true,
          titleText: Text(
            "عملیات",
            textAlign: TextAlign.right,
          ),
          messageText:
              Text("در حال کوتاه کردن لینک", textAlign: TextAlign.right));
      var json = await http
          .get(Uri.parse("http://g02.ir/api/v1/public/?link=$inputUrl"));
      return g02FromJson(json.body);
    } on SocketException {
      Get.snackbar("", "",
          titleText: Text(
            "اینترنت",
            textAlign: TextAlign.right,
          ),
          messageText: Text("اینترنت تلفن شما خاموش می باشد",
              textAlign: TextAlign.right));
    } catch (e) {
      Get.snackbar("", "",
          titleText: Text(
            "خطا",
            textAlign: TextAlign.right,
          ),
          messageText:
              Text("در ارتباط خطایی رخ داد", textAlign: TextAlign.right));
    }

    return G02(fullShortLink: "");
  }
}
