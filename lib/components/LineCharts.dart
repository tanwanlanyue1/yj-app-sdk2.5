import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

class LineCharts extends StatelessWidget {
  final String? facName;
  final String? unit;
  final int? warnLevel;
  final List? valueData;
  LineCharts({this.facName, this.warnLevel,this.unit, this.valueData});

  var themeColor; 
  void _colorSelect(int? level) {
    switch(level) {
      case 0: themeColor = 'rgba(102, 143, 255, 1)'; break;
      case 1: themeColor = 'rgba(144, 204, 0, 1)'; break;
      case 2: themeColor = 'rgba(255, 219, 0, 1)'; break; 
      case 3: themeColor = 'rgba(255, 134, 0, 1)'; break; 
      case 4: themeColor = 'rgba(102, 143, 255, 1)'; break;
      default: themeColor = 'rgba(102, 143, 255, 1)';
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(warnLevel);
    _colorSelect(warnLevel);
    return Echarts(
      option: '''
        {
          tooltip: {
            show: true,
            trigger: 'axis',
            // backgroundColor: 'rgba(148, 194, 255, 1)',
            position: function (point, params, dom, rect, size) {
              let x = 0;
              let y = 0;
              
              let pointX = point[0];
              let pointY = point[1];

              let boxWidth = size.contentSize[0];
              let boxHeight = size.contentSize[1];

              if (boxWidth > pointX) {
                x = 5;
              } else {
                x = pointX - boxWidth;
              }

              if (boxHeight > pointY) {
                y = 5;
              } else {
                y = pointY - boxHeight;
              }

              return [x, y];
            },
            formatter: (params) => {
              let date = new Date(params[0].data[0] + 8 * 3600 * 1000);
              date = date.toJSON().substr(0, 19).replace('T', ' ');
              return (
                "时间：" + date + '<br/>' +
                params[0].marker +params[0].seriesName+ '：' + params[0].data[1] + '$unit'
              );
            }
          },
          grid: {
            top: '10%',
            left: '1%',
            right: '5%',
            bottom: '5%',
            containLabel: true
          },
          xAxis: {
            type: 'time',
            boundaryGap: false,
            splitLine: {show: false},
            axisTick: {show: false},
            axisLine: {
              lineStyle: {
                type: 'solid',
                color: 'rgba(161, 166, 179, 0.6)',
                width: 1
              }
            },
            axisLabel: {
              textStyle: {
                color: 'rgba(161, 166, 179, 1)'
              }
            }
          },
          yAxis: {
            name: '$unit',
            nameTextStyle: {
              color: '#A1A6B3',
              fontSize: 12
            },
            type: 'value',
            axisTick: {show: false},
            axisLine: {show: false},
            axisLabel: {
              textStyle: {
                color: 'rgba(161, 166, 179, 1)'
              }
            },
            splitLine:{
              lineStyle: {
                color: 'RGBA(242, 243, 245, 0.8)',
                type: 'dotted'
              }
            }
          },
          series: [
            {
              name: '$facName',
              type: 'line',
              smooth: true,
              showSymbol: true,
              symbol: 'circle',
              symbolSize: 3,
              yAxisIndex: 0,
              itemStyle: {
                normal: {
                  color: '$themeColor',
                  lineStyle: {
                    width: 1,
                    shadowColor: '$themeColor',
                  }
                }
              },
              data: $valueData
            }
          ]
        }
      '''
    );
  }
}