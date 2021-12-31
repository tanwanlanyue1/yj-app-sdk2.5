import 'package:flutter/material.dart';
import 'package:scet_dz/utils/screen/Adapter.dart';
import 'package:scet_dz/utils/screen/screen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFView extends StatelessWidget {
  final String? pathPDF;
  PDFView({this.pathPDF});

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(Adapt.screenW(), px(Adapter.topBarHeight)),
        child: AppBar(
            title: Text(
                '报告查看',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: sp(Adapter.appBarFontSize)
                )
            ),
            elevation: 0,
            centerTitle: true
        ),
      ),
      body: SfPdfViewer.network(
        '$pathPDF',
        key: _pdfViewerKey,
      ),
      // body:SfPdfViewer.file(
      //   File(pathPDF),
      //   key: _pdfViewerKey,
      // ),
    );
  }
}