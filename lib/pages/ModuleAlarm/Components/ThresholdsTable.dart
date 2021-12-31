import 'package:flutter/material.dart';
import 'package:scet_dz/utils/screen/screen.dart';

class ThresholdsTable extends StatelessWidget {

  ThresholdsTable({this.thresholds});

  final List? thresholds;

  _tableRowList() {
    dynamic content;
    List<TableRow> tableList = <TableRow>[
      TableRow(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '等级',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0XFF707070), 
                fontSize: sp(24.0)
              )
            ),
          ),
          Text(
            '范围',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0XFF707070), 
              fontSize: sp(24.0)
            )
          ),
          Text(
            '单位',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0XFF707070), 
              fontSize: sp(24.0)
            )
          ),
        ]
      )
    ];
    thresholds?.forEach((item) {
      content = TableRow(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              '${item['level']}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0XFF222222), 
                fontSize: sp(26.0)
              )
            ),
          ),
          Text(
            '${item['range']}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0XFF707070), 
              fontSize: sp(26.0)
            )
          ),
          Text(
            '${item['unit']}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0XFF222222), 
              fontSize: sp(26.0)
            ),
          ),
        ]
        );
        tableList.add(content);
    });
    return tableList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Adapt.screenW(),
      child: Card(
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            1: FixedColumnWidth(120.0),
          },
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