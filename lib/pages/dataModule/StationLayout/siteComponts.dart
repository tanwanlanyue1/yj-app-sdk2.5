import 'package:flutter/material.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

///站点详情组件
class SiteComponents {
  ///物质蓝色卡片
  static Widget matterCard({required List data, Function? callBack}) {
    return Container(
      height: px(118.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: matterCardItem(item: data[index]),
            onTap: () {
              callBack!(index, data[index]['facId']);
            },
          );
        }),
    );
  }

  ///物质蓝色卡片每一项
  static Widget matterCardItem({required Map item}) {
    return Container(
      width: px(244.0),
      height: px(118.0),
      padding: EdgeInsets.only(top: px(15.0), left: px(18.0)),
      margin: EdgeInsets.only(left: px(16.0)),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/station/matterBg.png'),
          fit: BoxFit.cover)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: px(0.0)),
            child: Text(
              '${item['facName'] }',
              style: TextStyle(
                  fontSize: sp(30.0),
                  color: Colors.white,
                  fontFamily: "M"
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text.rich(
            TextSpan(text: '${item['value']}',
              style: TextStyle(
                fontSize: sp(30.0),
                color: Color(0XFFFFFFFF)
              ),
              children: <TextSpan>[
                TextSpan(text: ' ${item['unit']}', 
                  style: TextStyle(
                    fontSize: sp(25.0),
                    color: Color(0XB3FFFFFF)
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  ///物质的 标题+内容
  static Widget matterCardTextrow(
      {String? leftTitle,
      String? leftValue,
      String? rightTitle,
      String? rightValue}) {
    return Container(
      margin: EdgeInsets.only(top: px(14.0)),
      child: Row(
        children: [
          Expanded(
            child: matterCardText(title: '$leftTitle', value: '$leftValue'),
          ),
          Expanded(
            child: matterCardText(title: '$rightTitle', value: '$rightValue'),
          ),
        ],
      ),
    );
  }

  ///物质的 标题+内容
  static Widget matterCardText({String? title, String? value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: px(120.0),
          child: Text(
            '${title}:',
            style: TextStyle(fontSize: sp(26.0), color: Color(0xff787A80)),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: px(10.0)),
            child: Text(
              '${value}',
              style: TextStyle(
                  fontSize: sp(28),
                  color: Color(0xff2E2F33),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///白色卡片
  static Widget itemCard({required List<Widget> children}) {
    return Container(
      width: px(702.0),
      // height: px(256),
      margin: EdgeInsets.all(px(24.0)),
      padding: EdgeInsets.fromLTRB(px(16.0), px(24.0), px(22.0), px(24.0)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(px(16.0)))),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  ///蓝色标题
  static Widget title({ required String title}){
    return Text(
      title,
      style: TextStyle(
        color: Color(0xff4D7CFF),
        fontSize: sp(32),
        fontFamily: "M",
      ),
    );
  }

  /// 物质标题加内容
  static Widget itemTextRow({String? title, required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: px(24.0)),
      child: Row(
        children: [
          Container(
            child: Text(
              '${title}：',
              style: TextStyle(
                  fontSize: sp(30.0),
                  color: Color(0xff45474D),
                  fontFamily: "M"
              ),
            ),
          ),
          Expanded(
            child: child,
          )
        ],
      ),
    );
  }

  ///卡片每一行数据
  static Widget itemCardRows({
    bool isCenter = true,//是否居中显示 否则靠上
    bool isName = false,//是否人名
    String? title,//标题
    required String data,//内容
  }) {
    return Padding(
      padding: EdgeInsets.only(top: px(10)),
      child: Row(
        children: [
          Container(
              width: px(188),
              child: Text(
                  '${title}:',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Color(0XFF787A80),
                    fontSize: sp(28.0),
                  )
              )
          ),
          Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: px(3)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                          data,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: isName ? Color(0xff4D7CFF) : Color(0xff2E2F33),
                            fontSize: isName ?sp(28):sp(30.0),
                          )
                      ),
                    ),
                  ],
                ),
              )
          )
        ],
        crossAxisAlignment: isCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      ),
    );
  }
  ///查询按钮
  static Widget queryButton({Function? onTap}) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
          width: px(120.0),
          height: px(48.0),
          child: GestureDetector(
              onTap: (){
                onTap?.call();
              },
              child: Image.asset('assets/icon/report/search.png',
                  fit: BoxFit.cover))),
    );
  }
}
