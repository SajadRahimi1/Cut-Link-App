import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:short_link_app/controllers/zaya_controller.dart';
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
  final _requestController = Get.put(RequestController());
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

                  if (_webService.value == "zaya.io")
                    _requestController.zayaRequest(_inputLink);
                  if (_webService.value == "g02.ir")
                    _requestController.g02Request(_inputLink);
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
            Obx(() => _webService.value == "zaya.io"
                ? (_requestController.zaya.value.data.shortUrl.isNotEmpty
                    ? CustomCard(
                        link: _requestController.zaya.value.data.shortUrl)
                    : SizedBox())
                : _requestController.g02.value.fullShortLink.isNotEmpty
                    ? CustomCard(
                        link: _requestController.g02.value.fullShortLink)
                    : SizedBox())
          ],
        ),
      ),
    );
  }
}
