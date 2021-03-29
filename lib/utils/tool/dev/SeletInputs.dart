import 'package:flutter/material.dart';
import 'package:scet_app/utils/tool/listView/unListview.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';
///加载弹框
class SelectInput {
  static bool _isShowing = false;
  static List _currentDataList = [];
  static Map _currentData = {};
  static bool more =true;
  static List _strong = [];//缓存key

  ///展示
  static void showProgress(
      BuildContext context, {
        key,
        Function onTabs,
        List data,
        Map currentData,
        List currentDataList,
        bool more
      }) {
      RenderBox renderBox = key.currentContext.findRenderObject();
      Rect box = renderBox.localToGlobal(Offset.zero) & renderBox.size;

      // if(_strong.contains(key)){
      //   int index =_strong.indexOf(key);
      //   _currentData =
      // }else{
      //   _strong.add(key);
      // }

      // print('key${_strong.contains(key)}');
      Navigator.push(
        context,
        _PopRoute(
          position: box, //位置
          data: data, // 下拉数据
          child: WindowsPop(
              data: data,
              more: more,
              currentData: _currentData,
              currentDataList : _currentDataList,
              callback:(val) {
                if(more){  //多选
                  if(_currentDataList.contains(val)) {
                    _currentDataList.remove(val);
                    onTabs(_currentDataList);
                  } else {
                    _currentDataList.add(val);
                    onTabs(_currentDataList);
                  }
                  // widget.callback(_currentDataList);
                } else {
                  if(_currentData.toString() == val.toString()){
                    _currentData = null;
                  }else{
                    _currentData = val;
                  }
                  onTabs(_currentData);
                  Navigator.pop(context);
                }
              }
          ),
        ),
      );
  }
  ///销毁
  static void destroy(){
    _strong.clear();
  }

  ///隐藏
  static void dismiss(BuildContext context) {
    if (_isShowing) {
      Navigator.of(context).pop();
      _isShowing = false;
    }
  }
}

///Route
class _PopRoute extends PopupRoute {
  final Rect position; //出現的位置
  final List data; //数据
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  _PopRoute({@required this.child,this.position, this.data,});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return SizeTransition(
      sizeFactor: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
      child: CustomSingleChildLayout(
        delegate: DropDownMenuRouteLayout(
            position: position,
            menuHeight:data.length < 3 ? data.length * px(58) : 4 * px(58)),
        child: SizeTransition(
          sizeFactor: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        ),
      ),
    );
  }

  @override
  Duration get transitionDuration => _duration;
}

///显示的位置
class DropDownMenuRouteLayout extends SingleChildLayoutDelegate {
  final Rect position;
  final double menuHeight;

  DropDownMenuRouteLayout({this.position, this.menuHeight});

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // TODO: implement getConstraintsForChild
    return BoxConstraints.loose(
        Size(position.right - position.left, menuHeight));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // TODO: implement getPositionForChild
    return Offset(position.left, position.bottom);
  }

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    // TODO: implement shouldRelayout
    return true;
  }
}


///下拉菜单样式
class WindowsPop extends StatefulWidget {
  final List data; //数据
  final Map currentData;//单选内容
  final List currentDataList;//多选内容
  final bool more;//多选状态
  final callback;
  WindowsPop({
    this.data,
    this.currentData,
    this.currentDataList,
    this.more,
    this.callback,
    Key key}) : super(key: key);
  @override
  _WindowsPopState createState() => _WindowsPopState();
}

class _WindowsPopState extends State<WindowsPop> {

  List  _data = [];
  Map  _currentData;
  List _currentDataList;
  bool _more = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = widget.data;
    _currentData = widget.currentData;
    _currentDataList = widget.currentDataList;
    _more = widget.more;
  }
  @override
  void didUpdateWidget(WindowsPop oldWidget) {
    super.didUpdateWidget(oldWidget);
    _data = widget.data;
    _currentData = widget.currentData;
    _currentDataList = widget.currentDataList;
    _more = widget.more;
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
          decoration: BoxDecoration(
            color: Color(0XFFFFFFFF),
            border: Border.all(width: px(1.0),color: Color(0X99A1A6B3)),
            borderRadius: BorderRadius.all(Radius.circular(px(4.0))),
          ),
          child: ScrollConfiguration(
              behavior: OverScrollBehavior(),
              child: ListView.builder(
                  itemCount: _data.length,
                  padding: EdgeInsets.all(0),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: Container(
                        height: px(58.0),
                        width: double.infinity,
                        padding: EdgeInsets.only(left: px(16.0)),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(width: px(1.0),color: Color(0X99A1A6B3))),
                            color: (_more && _currentDataList.contains(_data[index]))
                                || _data[index].toString() == _currentData.toString()
                                ? Color(0XFFe6f7ff) : Colors.transparent
                        ),
                        child: Text('${_data[index]['name']}',style: TextStyle(fontSize: sp(26.0)),),
                      ),
                      onTap: (){
                        widget.callback(_data[index]);
                        setState(() {});
                      },
                    );
                  }
              )
          )
      ),
    );
  }
}