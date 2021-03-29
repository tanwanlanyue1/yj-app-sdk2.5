import 'package:flutter/material.dart';
// 国际标准时间转北京时间
// String _time = '2020-10-28T06:23:57.000Z' ==> '2020-10-28 14:23:57' ;
dateUtc(time){
  if(time.toString().indexOf('Z') != -1) {
    String _time = time.toString().replaceAll('Z', '-0800');
    _time = DateTime.parse(_time).toLocal().toString();
    return time.toString().indexOf('.000') == -1
        ? _time
        :_time.replaceAll('.000', '');
  }else{
    return time;
  }
}