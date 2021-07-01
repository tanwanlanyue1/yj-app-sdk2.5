import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

class LineCharts extends StatelessWidget {
  final String facName;
  final String unit;
  final bool showAxis;
  final int warnLevel;
  final List valueData;
  bool reload = true;
  LineCharts(
      {this.facName, this.showAxis, this.warnLevel, this.unit, this.valueData});

  var themeColor;
  List bgColor;
  void _colorSelect(int level) {
    switch (level) {
      case 0:
        bgColor = ['rgba(77, 124, 255, 0.3)', 'rgba(77, 124, 255, 0)'];
        themeColor = 'rgba(77, 124, 255, 1)';
        break;
      case 1:
        bgColor = ['rgba(144, 204, 0, 0.4)', 'rgba(255, 255, 255, 0)'];
        themeColor = 'rgba(144, 204, 0, 1)';
        break;
      case 2:
        bgColor = ['rgba(255, 219, 0, 1.0)', 'rgba(255, 255, 255, 0)'];
        themeColor = 'rgba(255, 219, 0, 1)';
        break;
      case 3:
        bgColor = ['rgba(255, 134, 0, 0.4)', 'rgba(255, 255, 255, 0)'];
        themeColor = 'rgba(255, 134, 0, 1)';
        break;
      case 4:
        bgColor = ['rgba(255, 51, 51, 0.5)', 'rgba(255, 255, 255, 0)'];
        themeColor = 'rgba(255, 51, 51, 0.7)';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _colorSelect(warnLevel);
    return Echarts(
        onLoad: (dynamic controller) {
          if (reload && Platform.isIOS) {
            controller.reload();
            reload = false;
          }
        },
        option: '''
        {
          tooltip: {
            show: $showAxis,
            trigger: 'axis',
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
            top: '17%',
            left: '1%',
            right: '5%',
            bottom: '2%',
            containLabel: true
          },
          xAxis: {
            type: 'time',
            boundaryGap: false,
            splitLine: {show: false},
            axisTick: {show: false},
            axisLine: {
              show: $showAxis,
              lineStyle: {
                type: 'solid',
                color: 'rgba(161, 166, 179, 0.6)',
                width: 1
              }
            },
            axisLabel: {
              show: $showAxis,
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
              show: $showAxis,
              textStyle: {
                color: 'rgba(161, 166, 179, 1)'
              }
            },
            splitLine:{
              show: $showAxis,
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
              areaStyle: {
                normal: {
                  color: new echarts.graphic.LinearGradient(0, 0, 0, ${showAxis ? 1 : 0},[{
                      offset: 0,
                      color: '${bgColor[0]}'
                    },
                    {
                      offset: 1,
                      color: '${bgColor[1]}'
                    }
                  ]),
                  shadowColor: '${bgColor[0]}',
                  shadowBlur: 20
                }
              },
              itemStyle: {
                normal: {
                  color: '$themeColor',
                  lineStyle: {
                    width: 1,
                    shadowColor: '$themeColor',
                    opactiy: 0.3,
                    shadowBlur: 10,
                    shadowOffsetY: 1
                  }
                }
              },
              data: $valueData,
              markPoint:{
                label: {
                  show: true,
                  position: "top",
                  distance: 4,
                  offset: [1, 1],
                  fontSize: 14
                },
                symbol: "circle",
                symbolSize: 6,
                symbolOffset: [0, 0],                          
                data: [{type: 'max', name: '浓度最大值'}],       
              }
            }
          ]
        }
      ''');
  }
}
