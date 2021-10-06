import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:short_link_app/screens/card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Body(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Body extends StatelessWidget {
  var _webService = "zaya.io".obs;
  String _inputLink = "";
  CustomCard customCard = CustomCard();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily: "yekan"),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              exit(0);
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
          ),
          title: Text(
            "کات لینک",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.white,
          elevation: 10,
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: TextField(
                onSubmitted: (value) {},
                textAlign: TextAlign.end,
                keyboardType: TextInputType.url,
                onChanged: (value) {
                  _inputLink = value;
                },
                decoration: InputDecoration(
                    hintTextDirection: TextDirection.ltr,
                    hintText: "لینک طولانی",
                    suffixIcon: Icon(Icons.link),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff067eed)),
              child: TextButton(
                onPressed: () {
                  if (_inputLink.length > 5) {
                    if (!_inputLink.startsWith("http")) {
                      _inputLink = "http://$_inputLink";
                      print(_inputLink);
                    }
                  }

                  if (_webService.value == "zaya.io") zaya(_inputLink);
                  if (_webService.value == "g02.ir") g02(_inputLink);
                },
                child: Text(
                  "🔗 کوتاه کن",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Obx(
              () => DropdownButton<String>(
                items: <String>["zaya.io", "g02.ir"].map((String values) {
                  return DropdownMenuItem<String>(
                    value: values,
                    child: Text(
                      values,
                    ),
                  );
                }).toList(),
                onChanged: (selected) {
                  _webService.value = selected.toString();
                },
                iconEnabledColor: Colors.black,
                focusColor: Colors.black,
                hint: Text("یک سرویس را انتخاب کنید"),
                value: _webService.value.toString(),
                autofocus: true,
              ),
            ),
            customCard
          ],
        ),
      ),
    );
  }

  void test(String ss) {
    customCard.setLink(ss);
  }

  List item = [];
  String _outputLink = "";
  Future<void> zaya(String inputUrl) async {
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
      var json =
          await http.post(Uri.parse("https://zaya.io/api/v1/links"), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization':
            'Bearer 80PoHzx2u0TtA2tfrrkZ3Ko4wn6p8cAlJccxs2HfECaRtFTYxbPrft1zcEwx',
      }, body: {
        'url': '$inputUrl'
      });

      item.clear();
      var jsonResponse = jsonDecode(json.body);
      item.add(jsonResponse);
      _outputLink = "https://zaya.io/" + item[0]['data']['alias'];
      print(_outputLink);
      customCard.setLink(_outputLink);
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
  }

  Future<void> g02(String inputUrl) async {
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
      print(json.body);
      item.clear();
      item.add(jsonDecode(json.body));
      print(item[0]['short_link']);
      _outputLink = "http://g02.ir/" + item[0]['short_link'];
      customCard.setLink(_outputLink);
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
  }
}
//Clipboard.setData(ClipboardData(text: "your text"));
