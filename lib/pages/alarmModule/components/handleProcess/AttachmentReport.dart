import 'package:flutter/material.dart';
import 'package:scet_app/pages/alarmModule/components/WidgetCheck.dart';
import 'package:scet_app/pages/dataModule/components/ReportCard.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class AttachmentReport extends StatefulWidget {
  @override
  _AttachmentReportState createState() => _AttachmentReportState();
}

class _AttachmentReportState extends State<AttachmentReport> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: px(24.0)),
      child: Column(
        children: [
          WidgetCheck.miniTitle(
              '附件报告',
              icon: 'assets/icon/alarm/AttachmentReport.png'
          ),
          ReportCard(data: {"title": '警情处理流程附件报告', "time": "2020-10-28 16:21", "fileAddress": "static/upload/data/pic/basic/第74期 沧州临港经济技术开发区有毒有害气体预警监测系统运行01月04日-01月11日一周监测报-1587631328000.pdf"})
        ],
      )
    );
  }
}