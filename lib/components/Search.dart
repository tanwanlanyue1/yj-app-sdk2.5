import 'package:flutter/material.dart';
import 'package:scet_dz/utils/screen/screen.dart';

class Search extends StatefulWidget {
  final Color bgColor;
  final Color textFieldColor;
  final hintText;
  final search;

  Search({
    this.bgColor = Colors.white,
    this.textFieldColor = Colors.white,
    this.hintText ='搜索',
    this.search
  });

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController(); //输入框控制器
  FocusNode _contentFocusNode = FocusNode();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: px(100.0),
      alignment: Alignment.center,
      color: widget.bgColor,
      child: Container(
        width: px(702.0),
        height: px(60.0),
        padding: EdgeInsets.only(left: px(15.0)),
        decoration: BoxDecoration(
          color: widget.textFieldColor,
          borderRadius: BorderRadius.circular(px(10.0)),
        ),
        child: TextField(
          maxLines: 1,
          style: TextStyle(fontSize: sp(28.0), textBaseline: TextBaseline.ideographic),
          controller: _controller,
          focusNode: _contentFocusNode,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: px(-3.0), left: px(-10.0)),
              hintText: widget.hintText,
              hintStyle: TextStyle(fontSize: sp(28.0), color: Color(0xff5C6066)),
              border: InputBorder.none,
              icon: Image.asset(
                'assets/icon/input/search.png',
                width: px(30.0),
                height: px(30.0),
                fit: BoxFit.cover,
              ),
              suffixIcon: Container(
                width: px(30.0),
                height: px(30.0),
                padding: EdgeInsets.symmetric(vertical: px(10.0)),
                child: GestureDetector(
                  onTap: () {
                    if (_controller.text == '') {
                      _contentFocusNode.unfocus();
                    } else {
                      _controller.clear();
                    }
                  },
                  child: Image.asset(
                    'assets/icon/input/close.png',
                    width: px(30.0),
                    height: px(30.0),
                  ),
                ),
              )),
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            widget.search(value);
          },
          onChanged: (value) {
            widget.search(value);
          },
          onEditingComplete: () {
            _contentFocusNode.unfocus();
          },
        ),
      ),
    );
  }
}
