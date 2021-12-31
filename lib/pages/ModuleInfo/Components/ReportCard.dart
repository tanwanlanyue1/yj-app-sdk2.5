import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:cs_app/components/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:cs_app/utils/dateUtc/dateUtc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cs_app/api/Api.dart';
import 'package:cs_app/utils/screen/screen.dart';

class ReportCard extends StatelessWidget {
  final Map data;
  ReportCard({required this.data});

  Future<File?> createFileOfPdfUrl(url) async {
    try{
      url = Api.BASE_URL_PC + '/yujing/' + url;
      print(url);
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = new File('$dir/$filename');
      await file.writeAsBytes(bytes);
      return file;
    }catch(e){
      BotToast.closeAllLoading();
    }
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
                    child: Image.asset('lib/assets/icon/pdf.png',
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
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          BotToast.showCustomLoading(
              ignoreContentClick: true,
              toastBuilder: (cancelFunc) {
                return Loading(cancelFunc: cancelFunc);
              }
          );

          final url = Api.BASE_URL_PC + '/yujing/' + data['fileAddress'];
          Navigator.pushNamed(context, '/report/details', arguments: url);
          // final url = data['fileAddress'];
          // createFileOfPdfUrl(url).then((file) {
          //   Navigator.pushNamed(context, '/report/details', arguments: file.path);
          // });
        });
  }
}
