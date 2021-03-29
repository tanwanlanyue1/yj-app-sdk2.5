class Api {
  static final BASE_URL_APP = 'https://cz.scet.com.cn:1443/hbapp';

  static final BASE_URL_PC = 'https://dev.scet.com.cn/cz/api';
  // static final BASE_URL_PC = 'https://cz.scet.com.cn/api';

  // static final BASE_URL = 'http://10.10.1.217:8900';
  static final BASE_URL = 'https://cz.scet.com.cn:1443/api';

  static final Map url = {

    "realStationInfo": BASE_URL_APP + '/station/realStationInfo', // 站点信息

    "realFactorNum": BASE_URL_APP + '/station/realtime', //浓度>0监测因子

    "reportList": BASE_URL_APP + '/report/list',  // 报告列表

    "stationFactor": BASE_URL_APP + '/station/factor',  // 站点因子

    "stationDevice": BASE_URL_APP + '/station/device',  // 站点设备

    "factorValueList": BASE_URL_APP + '/data/monitor',  // 站点设备

    "factorDescription": BASE_URL_APP + '/data/description',  // 因子描述

    "patrolUpload": BASE_URL_APP + '/patrol/upload',  // 上传巡检记录
    
    "patrolList": BASE_URL_APP + '/patrol/list',  // 获取巡检记录列表

    "maintainUpload": BASE_URL_APP + '/device/report/maintain',  // 上传设备检修记录
    
    "maintainList": BASE_URL_APP + '/device/maintain',  // 获取设备检修列表

    "parkBorder": BASE_URL_PC + '/geometries/park', // 园区界

    "company": BASE_URL_PC + '/geometries/company/point', // 企业

    "sensitive": BASE_URL_PC + '/geometries/sensitive/point', // 敏感点

    "riskSource": BASE_URL_PC + '/geometries/risk', // 风险源

    "installationUnit": BASE_URL_PC + '/geometries/installationUnit', // 装置单元

    "wastePoint": BASE_URL_PC + '/geometries/waste', // 废水

    "sitesAround": BASE_URL_PC + '/sites/around', // 溯源

    "eventDetails": BASE_URL_PC + '/events', // 事件详情 {?code}

    "addOrUpdate": BASE_URL_PC + '/events/addOrUpdate', // 事件添加或修改

    "createCode": BASE_URL_PC + '/events/code/create', // 创建事件编号 {?type}

    "actionAdvice": BASE_URL_PC + '/events/action/plan', // 行动建议

    "traceSource": BASE_URL_PC + '/events/traceSource', // 溯源清单

    "eventList": BASE_URL_PC + '/events/list',  // 事件列表 {?type}

    "taskList": BASE_URL_PC + '/events/subordinate', // 任务中心

    "dataPlural": BASE_URL_PC + '/data/plural/history', // 数据核查
    
    "chemicals": BASE_URL_PC + '/chemicals/mobile/list', // 所有监测因子

    "workingUrl": 'https://dev.scet.com.cn/cz/jianchafuzhu/dataapi.ashx', // 监管监察模块

    "latest": BASE_URL + '/alarm/latest', // 警情中心

    'dutys':BASE_URL + '/events/dutys', // 查看值班人员

    'partitions':BASE_URL + '/parks/partitions', //  获取所有分区资料

    'companys':BASE_URL + '/companys', //  获取所有企业资料

    'chemicalsList':BASE_URL + '/events/emergency/equipment/chemicals', //  查看监测的物质

    'equipments':BASE_URL + '/events/emergency/equipments', //  查看监测设备

    'resources':BASE_URL + '/events/emergency/resources', //  查看防护设备

    'alibabaBold':BASE_URL + '/static/ziti/Alibaba-PuHuiTi-Bold.ttf', //  Alibaba-PuHuiTi-Bold.ttf

    'alibabaMedium':BASE_URL + '/static/ziti/Alibaba-PuHuiTi-Medium.ttf', //  Alibaba-PuHuiTi-Medium.ttf

    'alibabaRegular':BASE_URL + '/static/ziti/Alibaba-PuHuiTi-Regular.ttf', //  Alibaba-PuHuiTi-Regular.ttf

    'login':BASE_URL_APP+ '/login' ,// 用户登录

  };

}