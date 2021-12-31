import 'package:scet_dz/utils/dateUtc/dateUtc.dart';
import 'package:flutter/material.dart';
import 'package:scet_dz/utils/screen/screen.dart';

class SamePointTable extends StatelessWidget {
  final List? samePoint;
  SamePointTable({this.samePoint});

  _tableRowList() {
    dynamic content;
    List<TableRow> tableList = <TableRow>[
      TableRow(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '站点',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0XFF707070), 
                fontSize: sp(24.0)
              )
            ),
          ),
          Text(
            '监测时间',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0XFF707070), 
              fontSize: sp(24.0)
            )
          ),
          Text(
            '浓度值',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0XFF707070), 
              fontSize: sp(24.0)
            )
          ),
        ]
      )
    ];

    samePoint?.isNotEmpty ?? false
    ? samePoint!.forEach((item) {
        content = TableRow(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                '${item['stName']}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF222222), 
                  fontSize: sp(26.0)
                )
              ),
            ),
            Text(
              "${dateUtc(item['time'])}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0XFF707070), 
                fontSize: sp(26.0)
              )
            ),
            Text(
              '${item['value']} ${item['unit']}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0XFF222222), 
                fontSize: sp(26.0)
              ),
            ),
          ]
          );
          tableList.add(content);
      })
    : tableList.add(
        TableRow(
          children: [
            Container(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                '无相关数据',
                style: TextStyle(
                  color: Color(0XFF707070), 
                  fontSize: sp(26.0)
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(),
          ]
        )
      );
    return tableList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Adapt.screenW(),
      child: Card(
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: { 1: FixedColumnWidth(120.0)},
          border: TableBorder(
            horizontalInside : BorderSide(
              color: Color.fromRGBO(133,144,178, 0.08),
              width: 1.0,
              style: BorderStyle.solid,
            )
          ),
          children: _tableRowList(),
        )
      )
    );
  }
}