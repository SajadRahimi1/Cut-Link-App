import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomCard extends StatelessWidget {
  var link = "".obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 10,
      height: MediaQuery.of(context).size.height / 3,
      child: Card(
          color: Color(0xffc1e5ff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 15,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffff7c1f),
                    boxShadow: [BoxShadow(blurRadius: 15)]),
                child: Obx(() => Text(
                      link.value,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => link.value.length > 6
                      ? Image(
                          image: NetworkImage(
                              "http://qr-code.ir/api/qr-code?d=${link.value}"),
                          height: MediaQuery.of(context).size.height / 4,
                        )
                      : Image(
                          image: AssetImage("asset/img.png"),
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width / 2.5,
                        )),
                  // FloatingActionButton(
                  //   onPressed: () {},
                  //   child: Icon(Icons.share),
                  // ),
                  Container(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 5),
                    child: FloatingActionButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: link.value));
                        Get.snackbar("", "",
                            titleText: Text(
                              "لینک کوتاه شده کپی شد",
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 1),
                            snackPosition: SnackPosition.BOTTOM,
                            icon: Icon(Icons.copy),
                            shouldIconPulse: false,
                            isDismissible: true);
                      },
                      child: Icon(Icons.copy),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }

  void setLink(String link) {
    this.link.value = link;
  }
}
//http://qr-code.ir/api/qr-code?d=
