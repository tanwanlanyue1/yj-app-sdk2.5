import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:scet_app/components/CasingPly.dart';
import 'package:scet_app/pages/mapModule/components/WarnCard.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/easyRefresh/easyRefreshs.dart';
import 'package:scet_app/utils/tool/screen/Adapter.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';
import 'package:scet_app/utils/tool/storage/data_storageKey.dart';
import 'package:scet_app/utils/tool/storage/storage.dart';

/// 页面状态
enum typeStatus {
  onRefresh, // 刷新
  onLoad // 加载
}
class IndustryCenter extends StatefulWidget {
  @override
  _IndustryCenterState createState() => _IndustryCenterState();
}

class _IndustryCenterState extends State<IndustryCenter> {

  List? _dataList; // 警情数据

  List<String> _dropDownHeaderItemStrings = ['状态', '告警级别', '站点',];

  List<SortCondition> _statusList = [
    SortCondition(name: '全部',   value:'',isSelected: true),
    SortCondition(name: '进行中', value:'0',isSelected: false),
    SortCondition(name: '已结束', value:'1', isSelected: false),
  ]; // 状态数组

  List<SortCondition> _warnList = [
    SortCondition(name: '全部', value:'', isSelected: true),
    SortCondition(name: '1级', value:'1',isSelected: false),
    SortCondition(name: '2级', value:'2',isSelected: false),
    SortCondition(name: '3级', value:'3',isSelected: false),
    SortCondition(name: '4级', value:'4',isSelected: false),
  ]; // 警告级别数组

  List stIdList = []; // 站点id数组
  SortCondition? _selectWarnList; // 告警级别选中值
  SortCondition? _selectStatusList; // 状态选中值

  GZXDropdownMenuController _dropdownMenuController = GZXDropdownMenuController();
  GlobalKey _stackKey = GlobalKey();
  ScrollController _scrollController = ScrollController();
  String _dropdownMenuChange = '';// 当前显示状态

  int _total = 10; // 总条数
  int _pageNo = 1; // 当前页码
  String _eventStatus = '';// 事件状态(1,已结束 0,进行中)
  String _level = ''; // 警情等级
  String _stId = ''; // 站点ID

  bool _enableLoad = true; // 是否开启加载
  EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器

  @override
  void initState() {
    super.initState();
    _selectWarnList = _warnList[0];
    _selectStatusList = _statusList[0];
    stIdList = StorageUtil().getJSON(StorageKey.RealStationInfo);
    _realtime(type: typeStatus.onRefresh);
  }

  /// 预警中心接口   type: 刷新 / 加载 ，  pageNo： 页码
  _realtime({typeStatus? type,int pageNo = 1}) async {
    var now = new DateTime.now();
    String startTime = now.add(new Duration(days: -30)).toString();
    Map<String, dynamic> _data = {
      'stId': _stId,
      'startTime': startTime,
      'eventStatus': _eventStatus,
      'level': _level,
      'hasPaging': 1,
      'pageNo': _pageNo,
      'pageSize': 5
    };
    var response = await Request().get(Api.url['latest'], data: _data);
    if(response['code'] == 200) {
      Map _data = response['data'];
      _pageNo++;
      if (mounted == true) {
        if(type == typeStatus.onRefresh) { 
          // 下拉刷新
          _onRefresh(data: _data['data'], total: _data['total']);
        }else if(type == typeStatus.onLoad) { 
          // 上拉加载
          _onLoad(data: _data['data'], total: _data['total']);
        }
      }
    }
  }
  // 下拉刷新
  _onRefresh({required List data,required int total}) {
    _total = total;
    _dataList = data;
    _enableLoad = true;
    _controller.resetLoadState();
    _controller.finishRefresh();
    setState(() {});
  }
  // 上拉加载
  _onLoad({required List data,required int total}) {
    _total = total;
    _dataList!.addAll(data);
    if(_dataList!.length >= total){
      _controller.finishLoad(noMore: true);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _dropdownMenuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(Adapt.screenW(), px(Adapter.topBarHeight)),
        child: AppBar(
          title: Text('警情中心', style: TextStyle(color: Colors.white, fontSize: sp(Adapter.appBarFontSize))),
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
                  items: _dropDownHeaderItemStrings.map((item) {
                    return GZXDropDownHeaderItem(item, iconData: Icons.expand_more);
                  }).toList(),
                  // GZXDropDownHeader对应第一父级Stack的key
                  stackKey: _stackKey,
                  // controller用于控制menu的显示或隐藏
                  controller: _dropdownMenuController,
                  onItemTap: (index) { },
                  height: px(64.0),
                  color: Colors.white,
                  style: TextStyle(color: Color(0xFF2E3033), fontSize: sp(28)),
                  dropDownStyle: TextStyle(
                    fontSize: sp(28.0),
                    color: Theme.of(context).primaryColor,
                  ),
                  iconColor: Color(0xff8A9099),
                ),
                Expanded(
                  child: _dataList == null 
                  ?
                    CasingPly.casingPly1() 
                  :
                    EasyRefresh.custom(
                      enableControlFinishRefresh: true,
                      enableControlFinishLoad: true,
                      topBouncing: true,
                      controller: _controller,
                      taskIndependence: false,
                      reverse: false,
                      // firstRefresh: true, // 首次刷新
                      footer: footers(),
                      header: headers(),
                      scrollController:_scrollController ,
                      onLoad: _enableLoad ? () async {
                        _realtime(type: typeStatus.onLoad, pageNo: _pageNo);
                      } : null,
                      onRefresh: () async {
                        _pageNo = 1;
                        _realtime(type: typeStatus.onRefresh, pageNo: _pageNo);
                      },
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            return WarnCard(data: _dataList![index]);
                          }, childCount: _dataList!.length),
                        ),
                      ],
                    )
                ),
              ],
            ),
            // 下拉菜单
            GZXDropDownMenu(
              // controller用于控制menu的显示或隐藏
              controller: _dropdownMenuController,
              animationMilliseconds: 300,
              menus: [
                GZXDropdownMenuBuilder(
                  dropDownHeight: px(65) * _statusList.length + 5,
                  dropDownWidget: _buildConditionListWidget(_statusList, (data) {
                    _dropDownHeaderItemStrings[0] = data.value == '' ? '状态' : data.name!;
                    _dropdownMenuController.hide();
                    _eventStatus = data.value!;
                    _controller.callRefresh();
                    // _scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.ease);
                    _realtime(type: typeStatus.onRefresh);
                  })
                ),
                GZXDropdownMenuBuilder(
                  dropDownHeight: px(65) * _warnList.length + 5,
                  dropDownWidget: _buildConditionListWidget(_warnList, (data) {
                    _dropDownHeaderItemStrings[1] = data.value == '' ? '告警级别' : data.name!;
                    _dropdownMenuController.hide();
                    _level = data.value!;
                    _controller.callRefresh();
                    _realtime(type: typeStatus.onRefresh);
                  })
                ),
                GZXDropdownMenuBuilder(
                  dropDownHeight: 40 * 8.0,
                  dropDownWidget: _buildAddressWidget(stIdList,(data) {
                    _dropDownHeaderItemStrings[2] = data['stName'];
                    _dropdownMenuController.hide();
                    _stId = data['stId'].toString();
                    _controller.callRefresh();
                    _realtime(type: typeStatus.onRefresh);
                  })
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  // 站点每一项
  _buildAddressWidget(items,void itemOnTap(Map selectValue)) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      separatorBuilder: (BuildContext context, int index) => Divider(height: 1.0),
      itemBuilder: (BuildContext context, int index) {
        Map goodsSortCondition = items[index];
        return GestureDetector(
          onTap: () {
            itemOnTap(goodsSortCondition);
          },
          child: Container(
            height: px(65),
            child: Row(
              children: <Widget>[
                SizedBox(width: 16,),
                Expanded(
                  child: Text(
                    goodsSortCondition['stName'],
                    style: TextStyle(
                      color: _stId == goodsSortCondition['stId'].toString()
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                    ),
                  ),
                ),
                _stId == goodsSortCondition['stId'].toString()
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
  // 状态，警情等级每一项
  _buildConditionListWidget(items, void itemOnTap(SortCondition sortCondition)) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      separatorBuilder: (BuildContext context, int index) => Divider(height: 1.0),
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
                SizedBox(width: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SortCondition {
  String? name;
  String? value;
  bool? isSelected;
  SortCondition({this.name, this.value, this.isSelected});
}
