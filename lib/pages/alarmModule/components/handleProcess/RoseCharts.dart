import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

class RoseCharts extends StatelessWidget {
  final windData;
  RoseCharts({this.windData});

  List windDirection = ['N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'];
  
  @override
  Widget build(BuildContext context) {
    return Echarts(
      option: '''
        {
          grid: {
            top: '0%',
            left: '0%',
            right: '0%',
            bottom: '0%',
            containLabel: true
          },
          tooltip: {
            formatter: '{b}：{c}次'
          },
          angleAxis: {
            type: 'category',
            data: ['N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'],
            z: 0,
            boundaryGap: false,
            splitLine: {
              show: true,
              lineStyle: {
                color: 'rgba(155, 193, 250, 0.2)',
                type: 'solid'
              }
            },
            axisLine: {
              show: false
            },
            axisTick: {
              show: true,
              lineStyle: {
                color: '#1F78FF',
                width: 2
              }
            },
            axisLabel: {
              textStyle: {
                color: '#A1A6B3',
                fontsize: '10px'
              }
            }
          },
          radiusAxis: {
            nameLocation: 'middle',
            splitArea: {
              show: false,
              areaStyle: {
                color: 'transparent'
              }
            },
            splitLine: {
              lineStyle: {
                color: 'rgba(155, 193, 250, .5)',
              }
            },
            axisLine: {
              show: true,
              lineStyle: {
                color: 'rgba(125, 175, 250, 1)'
              }
            },
            axisTick: {
              show: true,
              lineStyle: {
                color: 'rgba(125, 175, 250, 1)'
              }
            },
            axisLabel: {
              interval: 0,
              margin: 4,
              textStyle: {
                color: '#5973B3' // 刻度
              }
            }
          },
          polar: {
            center: ['50%', '50%'],
            radius: '80%'
          },
          series: ${json.encode(windDirection)}.map((item, index) => {
            let data = new Array(${windDirection.length}).fill(0); 
            data[index] = $windData[item]
            return {
              type: 'bar',
              itemStyle: {
                normal: {
                  color: '#4D7CFF',
                  fontsize: '10px'
                }
              },
              areaStyle: {
                normal: {
                  color: '#964EFF',
                  fontsize: '10px'
                }
              },
              data: data,
              coordinateSystem: 'polar',
              stack: 'a'
            };
          })
        }
      ''',
    
    );
  }
}