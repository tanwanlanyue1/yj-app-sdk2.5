import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scet_app/utils/tool/dateUtc/dateUtc.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class ReportCard extends StatelessWidget {
  final Map data;
  ReportCard({this.data});

  Future<File> createFileOfPdfUrl(url) async {
    url = 'https://cz.scet.com.cn:1443/api/yujing/' + url;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Card(
            color: Color(0XFFFFFFFF),
            margin: EdgeInsets.only(top: px(24.0)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(px(16.0)))),
            child: Container(
                width: Adapt.screenW(),
                padding: EdgeInsets.all(px(24.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: px(100.0),
                        height: px(120.0),
                        margin: EdgeInsets.only(right: px(20.0)),
                        child: Image.asset('assets/icon/report/pdf.png',
                            fit: BoxFit.cover)),
                    Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text("${data['title']}",
                              style: TextStyle(
                                color: Color(0XFF45474D),
                                fontSize: sp(28.0),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1),
                          Container(
                              width: Adapt.screenW(),
                              padding: EdgeInsets.only(top: px(20.0)),
                              child: Text(
                                dateUtc(data['time']),
                                style: TextStyle(
                                  color: Color(0XFF8A8E99),
                                  fontSize: sp(26.0),
                                ),
                                textAlign: TextAlign.end,
                              ))
                        ]))
                  ],
                ))),
        onTap: () {
          final url = data['fileAddress'];
          createFileOfPdfUrl(url).then((file) {
            Navigator.pushNamed(context, '/data/report/details',
                arguments: file.path);
          });
        });
  }
}
