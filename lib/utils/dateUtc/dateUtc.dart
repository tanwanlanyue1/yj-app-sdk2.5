import 'package:date_format/date_format.dart';

String dateUtc(String time) {
  return formatDate(DateTime.parse(time).toLocal() ,[yyyy,'-',mm,'-',dd, ' ',HH,':',nn,':',ss]);
}