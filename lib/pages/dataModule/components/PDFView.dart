import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:scet_app/utils/tool/screen/Adapter.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class PDFView extends StatelessWidget {
  final String pathPDF;
  PDFView({this.pathPDF});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
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
      path: pathPDF
    );
  }
}