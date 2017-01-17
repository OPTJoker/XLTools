//
//  Links.h
//  iUnis
//
//  Created by 张雷 on 16/10/9.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#ifndef Links_h
#define Links_h


#endif /* Links_h */

// 远程服务器
#define KSERVER @"http://weshape3d.wicp.io:11250/"
// 本地服务器
//#define KSERVER @"http://192.168.6.168:9696/"

// DDL测试服务器
//#define KSERVER @"http://192.168.6.53:8888/"



//根据机床号获取合同信息
#define KGETCONTRACTINFOBYPROID @"/api/IUnisGateway/GetContractInfo?ProductID="

//根据机床号获取一二类件
#define KGETPROGRESSBYID @"api/IUnisGateway/GetProdProgByID?ProdID="

/* 根据proID更改机床状态
 @ "productID": "sample string 1",
 @ "status": 2
 */
#define KURL_POSTUPDATEMACHINESTATUS @"api/IUnisGateway/UpdataMachineStatus"

////////////////////////////////////////////////////////////////////////
/////////                      物流运输                         /////////
////////////////////////////////////////////////////////////////////////
/*   api/IUnisGateway/UpdataMachineListStatus   【POST】
Factory 批量更改机器的状态
用处：iFactory移动客户端->物流运输->确认发货/取消发货
参数：
{
    "status": 状态 （1确认发送 2取消发送）
    "ProductIDs": [
    { "ProductID": "i51630003" },
    { "ProductID": "i51630037" },
    { "ProductID": "i51620052" }]
}
返回：
{
    "code":0,
    "message":"i51630003,i51630037不符合条件",
    "result":false,
    "data":null 
}
*/
#define KURL_POST_LogisticUpdateMachineStatus @"api/IUnisGateway/UpdataMachineListStatus"


////////////////////////////////////////////////////////////////////////
/////////                      订单列表                         /////////
////////////////////////////////////////////////////////////////////////

// 获取包装平台数量
#define KURL_GETPACKAGENUMBERS @"api/IUnisGateway/GetNumofPackagingAndPackaged"
// 获取进行中机床列表
#define KURL_GETONGOINGMACHINES @"api/IUnisGateway/GetMachineStatus"


////////////////////////////////////////////////////////////////////////
/////////                      生产线查询                        /////////
////////////////////////////////////////////////////////////////////////

// 查询全部生产线和工位状态
#define KURL_GETALLPRODUCTLINE @"api/IFactoryLog/GetAllAsmblyStations"

// 查询生产日志
#define KURL_GETALLLOG @"api/IFactoryLog/GetFullLog?ProductID="

// 根据日志id查询详细日志
// POST:    {LogID: "29860", LogType: "1"}
#define KURL_GETDETAILLOG @"/api/IFactoryLog/GetDetailLog"
// 根据productID查询红牌信息
#define KURL_GETPROBLEMLOGBYPROID @"api/IFactoryLog/GetAsmblyProbLog?ProductID="
// 根据工位和生产线ID获取操作人员头像
#define KURL_GETWORKERHEADER @"api/IFactoryLog/GetUsersInfo"

///////////////////////////////////////////////////////////////////////
///////////                    消息 队列                     ///////////
///////////////////////////////////////////////////////////////////////
#define KMSGQUEUE @"MSGQUEUQ"       // 本地消息列表
#define KNewMSGCount @"NewMsgCount" // 未读消息数
#define KNewMSGDic @"NewMsgDic"     //未读消息列表字典

#define KURL_GETMSGLISTBYUSERID @"api/MsQueue/GetMqList?userID="

