class Api {
  static final BASE_URL_APP = 'https://cq.scet.com.cn/app';

  static final BASE_URL_PC = 'https://cq.scet.com.cn/api';
  // static final BASE_URL_PC = 'http://10.10.1.217:9700';

  static final Map url = {

    "userLogin": BASE_URL_APP + '/login', // 用户登录

    "userInfo": BASE_URL_APP + '/users/getCurrentUser', // 用户信息

    // "alarmCount": BASE_URL_APP + '/alarm/station', // 当天警情 > 0
    "alarmCount": BASE_URL_PC + '/alarm/sites/number', // 当天警情 > 0

    "threshold": BASE_URL_PC + '/alarm/sites/each/threshold', // 查询四种类型警情


    "historyAlarm": BASE_URL_APP + '/alarm/historydata', // 历史警情

    // "alarmLine": BASE_URL_APP + '/alarm/factor/historydata', // 警情浓度

    "alarmLine": BASE_URL_PC + '/data/history', // 警情浓度

    "table": BASE_URL_PC + '/alarm/table', // 历史警情

    // "alarmLine": BASE_URL_APP + '/alarm/factor/historydata', // 警情浓度

    "samePoint": BASE_URL_APP + '/data/getLatestData', // 同类点位

    "factorThresholds": BASE_URL_APP + '/data/warnThresholds', // 物质阈值

    // "realStationInfo": BASE_URL_APP + '/station/realStationInfo', // 站点信息
    "realStationInfo": BASE_URL_PC + '/data/latest', // 站点信息

    "realFactorNum": BASE_URL_APP + '/station/realtime', // 浓度>0监测因子

    "reportList": BASE_URL_APP + '/report/list',  // 报告列表

    // "stationFactor": BASE_URL_APP + '/station/factor',  // 站点因子
    "stationFactor": BASE_URL_PC + '/data/sites/latest',  // 站点因子

    // "stationDevice": BASE_URL_APP + '/station/device',  // 站点设备
    "stationDevice": BASE_URL_PC + '/instruments/site',  // 站点设备

    // "factorValueList": BASE_URL_APP + '/data/monitor',  // 因子趋势
    "factorValueList": BASE_URL_PC + '/data/history',  // 因子趋势

    "factorDescription": BASE_URL_APP + '/data/description',  // 因子描述

    "patrolUpload": BASE_URL_APP + '/patrol/upload',  // 上传巡检记录
    
    "patrolList": BASE_URL_APP + '/patrol/list',  // 获取巡检记录列表

    "maintainUpload": BASE_URL_APP + '/device/report/maintain',  // 上传设备检修记录
    
    "maintainList": BASE_URL_APP + '/device/maintain',  // 获取设备检修列表

    "versions": BASE_URL_PC + '/versions', // 更新

    "parkBorder": BASE_URL_PC + '/geometries/park', // 园区界

    "company": BASE_URL_PC + '/geometries/company/point', // 企业

    "sensitive": BASE_URL_PC + '/geometries/sensitive/point', // 敏感点

    "riskSource": BASE_URL_PC + '/geometries/risk', // 风险源

    "installationUnit": BASE_URL_PC + '/geometries/installationUnit', // 装置单元

    "monitorDevice": BASE_URL_PC + '/geometries/monitor', // 监测设备

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

    "jpush": BASE_URL_PC + '/jpush', // 极光
  };

}