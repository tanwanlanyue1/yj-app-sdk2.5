import 'package:flutter/material.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:scet_app/components/CasingPly.dart';
import 'package:scet_app/pages/userModule/components/BacklogComponents.dart';
import 'package:scet_app/utils/tool/screen/Adapter.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class SortCondition {
  String? name;
  bool? isSelected;
  SortCondition({this.name, this.isSelected});
}

class MyBacklog extends StatefulWidget {
  @override
  _MyBacklogState createState() => _MyBacklogState();
}

class _MyBacklogState extends State<MyBacklog> {
  List _jobList = [];
  List<String> _dropDownHeaderItemStrings = ['状态', '任务类型',];
  String _dropdownMenuChange = '';
  GlobalKey _stackKey = GlobalKey();

  SortCondition? _selectStatusList; // 状态数组选中值
  SortCondition? _selectTypeList; // 任务类型选中值
  GZXDropdownMenuController _dropdownMenuController = GZXDropdownMenuController();

  List<SortCondition> _statusList = []; // 状态数组
  List<SortCondition> _typeList = []; // 任务类型

  @override
  void initState() {
    super.initState();

    _typeList.add(SortCondition(name: '全部', isSelected: true));
    _typeList.add(SortCondition(name: '1级', isSelected: false));
    _typeList.add(SortCondition(name: '2级', isSelected: false));
    _typeList.add(SortCondition(name: '3级', isSelected: false));
    _typeList.add(SortCondition(name: '4级', isSelected: false));

    _selectTypeList = _typeList[0];

    _statusList.add(SortCondition(name: '全部', isSelected: true));
    _statusList.add(SortCondition(name: '未开始', isSelected: false));
    _statusList.add(SortCondition(name: '进行中', isSelected: false));
    _statusList.add(SortCondition(name: '已完成', isSelected: false));

    _selectStatusList = _statusList[0];
    myJop();
  }

  //获取我的待办接口
  myJop(){
    Future.delayed(const Duration(milliseconds: 1000), () {
      //延时执行的代码
      List respone =  [
        {
          'title':'A村最大落地浓度点监测任务',
          'status':'1',
          'taskId':'JC-20201002-B01',
          'event':'TS-20200928-1',
          'explain':'A村防护边界预估最大落地浓度点监测，请前往监测NH3具体浓度数值。',
          'time':'2020-10-02 10:00',
          'executor':'杨大锤',
        },
        {
          'title':'A村最大落地浓度点监测任务',
          'status':'0',
          'taskId':'JC-20201002-B01',
          'event':'TS-20200928-1',
          'explain':'A村防护边界预估最大落地浓度点监测，请前往监测',
          'time':'2020-10-02 10:00',
          'executor':'张小祥',
        },
        {
          'title':'A村最大落地浓度点监测任务',
          'status':'2',
          'taskId':'JC-20201002-B01',
          'event':'TS-20200928-1',
          'explain':'A村防护边界预估最大落地浓度点监测，请前往监测',
          'time':'2020-10-02 10:00',
          'executor':'杨大锤',
        }
      ]; //警情数据
      if(mounted == true){
        setState(() {
          _jobList = respone;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(Adapt.screenW(), px(Adapter.topBarHeight)),
        child: AppBar(
            title: Text(
                '我的待办',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: sp(Adapter.appBarFontSize)
                )
            ),
            elevation: 0,
            centerTitle: true
        ),
      ),
      body: Container(
        child: Stack(
          key: _stackKey,
          children: <Widget>[
            Column(
              children: <Widget>[
                GZXDropDownHeader(
                  // 下拉的头部项，目前每一项，只能自定义显示的文字、图标、图标大小修改
                  items: [
                    GZXDropDownHeaderItem(_dropDownHeaderItemStrings[0], iconData: Icons.expand_more),
                    GZXDropDownHeaderItem(_dropDownHeaderItemStrings[1], iconData: Icons.expand_more),
                  ],
                  // GZXDropDownHeader对应第一父级Stack的key
                  stackKey: _stackKey,
                  // controller用于控制menu的显示或隐藏
                  controller: _dropdownMenuController,
                  onItemTap: (index) {
                    print('==>${index}');
                  },
                  height: px(64),
                  color: Colors.white,
                  style: TextStyle(color: Color(0xFF2E3033), fontSize: sp(28)),
                  dropDownStyle: TextStyle(
                    fontSize: sp(28),
                    color: Theme.of(context).primaryColor,
                  ),
                  iconColor: Color(0xff8A9099),
                ),
                Expanded(
                  child:_jobList.isEmpty ?
                  CasingPly.casingPly4()  :
                  ListView.builder(
                    itemCount: _jobList.length,
                    padding: EdgeInsets.only(top: px(24)),
                    itemBuilder: (BuildContext context, int index) {
                      return BacklogComments.itemCard(
                        title: _jobList[index]['title'],
                        status:  _jobList[index]['status'],
                        taskId: _jobList[index]['taskId'],
                        event: _jobList[index]['event'],
                        explain: _jobList[index]['explain'],
                        time: _jobList[index]['time'],
                        executor: _jobList[index]['executor'],
                      );
                    }
                  ),
                ),
              ],
            ),
            // 下拉菜单
            GZXDropDownMenu(
              // controller用于控制menu的显示或隐藏
              controller: _dropdownMenuController,
              animationMilliseconds: 300,
              dropdownMenuChanging: (isShow, index) {
                setState(() {
                  _dropdownMenuChange = '(正在${isShow ? '显示' : '隐藏'}$index)';
                  print(_dropdownMenuChange);
                });
              },
              dropdownMenuChanged: (isShow, index) {
                setState(() {
                  _dropdownMenuChange = '(已经${isShow ? '显示' : '隐藏'}$index)';
                  print(_dropdownMenuChange);
                });
              },
              // 下拉菜单，高度自定义，你想显示什么就显示什么，完全由你决定，你只需要在选择后调用_dropdownMenuController.hide();即可
              menus: [
                GZXDropdownMenuBuilder(
                  dropDownHeight: px(65) * _statusList.length + 5,
                  dropDownWidget: _buildConditionListWidget(_statusList, (value) {
                    _selectStatusList = value;
                    _dropDownHeaderItemStrings[0] =
                    _selectStatusList!.name == '全部' ? '状态' : _selectStatusList!.name!;
                    _dropdownMenuController.hide();
                    setState(() {});
                  })
                ),
                GZXDropdownMenuBuilder(
                  dropDownHeight: px(65) * _typeList.length + 5,
                  dropDownWidget: _buildConditionListWidget(_typeList, (value) {
                    _selectTypeList = value;
                    _dropDownHeaderItemStrings[1] =
                    _selectTypeList!.name == '全部' ? '任务类型' : _selectTypeList!.name!;
                    _dropdownMenuController.hide();
                    setState(() {});
                  })
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  _buildConditionListWidget(items, void itemOnTap(SortCondition sortCondition)) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      separatorBuilder: (BuildContext context, int index) =>
          Divider(height: 1.0),
      // 添加分割线
      itemBuilder: (BuildContext context, int index) {
        SortCondition goodsSortCondition = items[index];
        return GestureDetector(
          onTap: () {
            for (var value in items) {
              value.isSelected = false;
            }
            goodsSortCondition.isSelected = true;
            itemOnTap(goodsSortCondition);
          },
          child: Container(
            height: px(65),
            child: Row(
              children: <Widget>[
                SizedBox(width: 16,),
                Expanded(
                  child: Text(
                    goodsSortCondition.name!,
                    style: TextStyle(
                      color: goodsSortCondition.isSelected!
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                  ),
                ),
                goodsSortCondition.isSelected!
                    ? Icon(Icons.check, color: Theme.of(context).primaryColor, size: 16,)
                    : SizedBox(),
                SizedBox(width: 16,),
              ],
            ),
          ),
        );
      },
    );
  }
}
