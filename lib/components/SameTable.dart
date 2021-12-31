import 'package:flutter/material.dart';
import 'package:cs_app/utils/screen/screen.dart';

class SameTable extends StatefulWidget {
  final List? tableHeader;
  final List tableBody;
  final Function? callBack;//下一页
  final Function? callPrevious;//上一页
  SameTable({
    Key? key,
    this.tableHeader,
    required this.tableBody,
    this.callBack,
    this.callPrevious,
  }) : super(key: key);

  @override
  _SameTableState createState() => _SameTableState();
}

class _SameTableState extends State<SameTable> {
  bool show = false;
  List tableHeader = [];
  List tableBody = [];

  @override
  void initState() {
    show = widget.callBack !=null ? true : false;
    tableHeader = widget.tableHeader ?? [];
    tableBody = widget.tableBody;
    super.initState();
  }

  List<Widget> bodyRow(item,{bool isHeader = false}){
    List<Widget> bodyRow = [];
    for(var i=0;i<item.length;i++){
      bodyRow.add(
        Expanded(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                  border: isHeader ? Border(bottom: BorderSide(width: px(1),color: Colors.black38)) : null
              ),
              child: Container(
                // width: px(120),
                alignment: Alignment.center,

                child: Text(
                    '${item[i]}',
                    style: TextStyle(
                        color: Color(0XFF707070),
                        fontSize: sp(24.0)
                    )
                ),
              )
          ),
        )
      ) ;
    }
    return bodyRow;
  }

  @override
  void didUpdateWidget(SameTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    show = widget.callBack!=null ? true:false;
    tableHeader = widget.tableHeader ?? [];
    tableBody = widget.tableBody;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Row(
        children: [
          Visibility(
            visible: show,
            child: InkWell(
              onTap: (){
                widget.callPrevious?.call();
              },
              child: Container(
                width: px(50),
                height: px(150),
                child: Icon(Icons.chevron_left_outlined,size: 26,),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: bodyRow(tableHeader,isHeader:true),
                ),
                Column(
                  children: List.generate(tableBody.length, (i) {
                    return  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: bodyRow(tableBody[i]),);
                  }),
                ),
              ],
            ),
          ),
          Visibility(
            visible: show,
            child: InkWell(
              onTap: (){
                widget.callBack?.call();
              },
              child: Container(
                height: px(150),
                child: Icon(Icons.chevron_right_outlined,size: 26,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

