String warnLevel(level) {
  String warnState;
  switch (level) {
    case 1: warnState = "异常级(1级)"; break;
    case 2: warnState = "注意级(2级)"; break;
    case 3: warnState = "警告级(3级)"; break;
    case 4: warnState = "高报级(4级)"; break;
    default: warnState = "正常";
  }
  return warnState;
}