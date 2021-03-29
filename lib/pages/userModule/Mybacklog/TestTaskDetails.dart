import 'package:flutter/material.dart';
import 'package:scet_app/pages/userModule/components/TaskDetailsComponents.dart';
import 'package:scet_app/utils/tool/screen/Adapter.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class TestTaskDetails extends StatefulWidget {
  @override
  _TestTaskDetailsState createState() => _TestTaskDetailsState();
}

class _TestTaskDetailsState extends State<TestTaskDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(Adapt.screenW(), px(Adapter.topBarHeight)),
        child: AppBar(
          title: Text(
            '监测任务详情',
            style: TextStyle(
              color: Colors.white,
              fontSize: sp(Adapter.appBarFontSize)
            )
          ),
          elevation: 0,
          centerTitle: true
        ),
      ),
      body: ListView(
        children: [
          TaskComponents.title(
            title:'A村最大落地浓度点监测任务',
            status: '1'
          ),
          TaskComponents.itemCard(
            title:'基础信息',
            child: Column(
              children: [
                TaskComponents.itemCardRows(
                  title: '任务编号',
                  data: 'JC-20201002-B01'
                ),
                TaskComponents.itemCardRows(
                  title: '关联事件',
                  data: 'TS-20200928-1'
                ),
                TaskComponents.itemCardRows(
                  isCenter: false,
                  title: '任务说明',
                  data: 'A村防护边界预估最大落地浓度点监测，请前往监测'
                ),
                TaskComponents.itemCardRows(
                  title: '执行时间',
                  data: '2020-10-02 10:00'
                ),
                TaskComponents.itemCardRows(
                  title: '执 行 人 ',
                  data: '杨大锤',
                  isName: true
                ),
                TaskComponents.itemCardRows(
                  title: '发布人员',
                  data: '胡小鑫',
                  isName: true
                ),
                TaskComponents.itemCardRows(
                  title: '发布时间',
                  data: '2020-10-02 09:00:30',
                ),
                TaskComponents.itemCardRows(
                  title: '发布平台',
                  data: '系统、APP、短信通知',
                ),
              ],
            )
          ),
          TaskComponents.itemCard(
            title:'监测点位信息',
            child: Column(
              children: [
                TaskComponents.itemCardRows(
                  title: '目标序号',
                  data: '2P'
                ),
                TaskComponents.itemCardRows(
                  title: '所在位置',
                  data: '1117.507286, 38.3536',
                  isMap: true
                ),
                TaskComponents.itemCardRows(
                  title: '点位名称',
                  data: 'A村防护边界点1'
                ),
                TaskComponents.itemCardRows(
                  title: '类型说明',
                  data: '/'
                ),
                TaskComponents.itemCardRows(
                  title: '目标物质',
                  data: '乙苯；苯乙烯；',
                ),
                TaskComponents.itemCardRows(
                  title: '监测配置',
                  data: '便携式傅立叶红外光谱分析仪',
                ),
                TaskComponents.itemCardRows(
                  title: '防护配置',
                  data: '防化服1套',
                ),
                TaskComponents.itemCardRows(
                  title: '其他说明',
                  data: '无',
                ),
                Divider(
                  height: px(25),
                  color: Color(0x807A92CC),
                ),
                TaskComponents.itemCardRows(
                  title: '目标序号',
                  data: '1P'
                ),
                TaskComponents.itemCardRows(
                  title: '所在位置',
                  data: '1117.507286, 38.3536',
                  isMap: true
                ),
                TaskComponents.itemCardRows(
                  title: '点位名称',
                  data: 'A村防护边界点1'
                ),
                TaskComponents.itemCardRows(
                  title: '类型说明',
                  data: '/'
                ),
                TaskComponents.itemCardRows(
                  title: '目标物质',
                  data: '乙苯；苯乙烯；',
                ),
                TaskComponents.itemCardRows(
                  title: '监测配置',
                  data: '便携式傅立叶红外光谱分析仪',
                ),
                TaskComponents.itemCardRows(
                  title: '防护配置',
                  data: '防化服1套',
                ),
                TaskComponents.itemCardRows(
                  title: '其他说明',
                  data: '无',
                ),
              ],
            )
          ),
          _btn()
        ],
      ),
    );
  }
  Widget _btn(){
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: px(64),
        width: px(702),
        margin: EdgeInsets.all(px(24)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xff4D7CFF),
          borderRadius: BorderRadius.all(Radius.circular(px(8)))
        ),
        child: Text(
          '填 写 任 务 报 告',
          style: TextStyle(
            color: Colors.white,
            fontSize: sp(28)
          ),
        ),
      ),
    );
  }
}
