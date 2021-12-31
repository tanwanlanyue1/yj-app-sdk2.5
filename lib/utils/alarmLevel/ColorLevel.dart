import 'package:flutter/material.dart';

List<dynamic> colorSelest(int level) {
    var bgColor, levelColor;
    switch(level) {
      case 0: bgColor = [Color(0xFFFFFFFF), Color(0xFFFFFFFF)]; 
              levelColor = Color(0XFF222222); 
              break;
      case 1: bgColor = [Color(0XFFF6C12D), Color(0XFFEBD510)]; 
              levelColor = Color(0XFF2089F6); 
              break;
      case 2: bgColor = [Color(0XFFFF8235), Color(0XFFFDA83E)]; 
              levelColor = Color(0XFFFBC41A); 
              break; 
      case 3: bgColor = [Color(0XFFF6C12D), Color(0XFFEBD510)]; 
              levelColor = Color(0XFFFF8F38); 
              break; 
      case 4: bgColor = [Color(0XFFFD473B), Color(0XFFFD5F50)]; 
              levelColor = Color(0xFFfd483c);
              break; 
      default: bgColor = [Color(0xFFFFFFFF), Color(0xFFFFFFFF)]; 
               levelColor = Color(0XFF222222);
    }
    return [bgColor, levelColor];
  }