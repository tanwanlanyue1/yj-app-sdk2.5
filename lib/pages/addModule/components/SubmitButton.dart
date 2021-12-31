import 'package:flutter/material.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class SubmitButton extends StatelessWidget {
  final Function? function;
  SubmitButton({this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: px(6.0)),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 1,
              child: InkWell(
                onTap: () { Navigator.pop(context); },
                child: Image.asset('assets/icon/other/cancel.png'),
              )
          ),
          Container(width: px(40.0)),
          Expanded(
              flex: 1,
              child: InkWell(
                onTap: (){
                  function?.call();
                },
                child: Image.asset('assets/icon/other/publish.png'),
              )
          ),
        ]
      ),
    );
  }
}