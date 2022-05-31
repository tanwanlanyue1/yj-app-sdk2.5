import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scet_app/components/LoadingDialog.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/tool/dateUtc/dateUtc.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class ReportCard extends StatelessWidget {
  final Map data;
  ReportCard({required this.data});

  Future<String?> createFileOfPdfUrl(url) async {
    BotToast.showCustomLoading(
        ignoreContentClick: true,
        toastBuilder: (cancelFunc) {
          return LoadingDialog();
        }
    );
    url = Api.BASE_URL_PC + "/yujing/" + url;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    return HttpClient().getUrl(Uri.parse(url)).then((value) async {
      var response = await value.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File('$dir/$filename');
      await file.writeAsBytes(bytes);
      BotToast.closeAllLoading();
      return file.path;
    }).catchError((err){
      return '';
    });
  }
  String pdf = '';
  String pdfFile = '';
  // Future init() async {
  //   pdf = (await getApplicationDocumentsDirectory()).path+"/fontDownload/";
  //   pdfFile = pdf + "pdf";
  // }
  //
  // downLoad() async {
  //   await Request().download("https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
  //     pdfFile,);
  // }
  Future<void> createDirectory(String path) async {
    Directory directory = Directory(path);
    directory.create();
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
                        child: Image.asset(
                            'lib/assets/icon/${data['contentType'] == 'docx' ? 'word' : 'pdf' }.png',
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
        onTap: ()async{
          //下载文件
          final url = data['fileAddress'];
          String? path = await createFileOfPdfUrl(url);
          if (path != '' && path != null) {
            OpenFile.open(path);
          }
          // createFileOfPdfUrl(url).then((file) {
          //   Navigator.pushNamed(context, '/data/report/details',
          //       arguments: file.path);
          // });
        });
  }
}
