//
//  TaskConst.swift
//  TaskApp
//
//  Created by 與倉利将 on 2017/11/25.
//  Copyright © 2017年 與倉利将. All rights reserved.
//

import UIKit

class TaskConst: NSObject {

    let FOR_KEY = "taskProperty"
    
    let FILTER_LIST = ["今日", "明日", "1週間以内", "期間無し"]
    let CATEGORY_LIST = ["カテゴリー無し", "仕事", "プライベート"]
    
    // カテゴリー
    let ALL = "全て"
    let NONE = "NONE"
    let WORK = "WORK"
    let PRIVATE = "PRIVATE"
    
    enum CATEGORY:String {
        case ALL = "ALL"
        case NONE = "NONE"
        case WORK = "WORK"
        case PRIVATE = "PRIVATE"
    }
    
    // 日時設定
    let JA_LOCALE = Locale(identifier: "ja_JP")
    let UTC_LOCALE = Locale(identifier: "utc")
    let DATE_FORMAT  = "yyyy年MM月dd日 HH時mm分"
    
//    let TEXT_DATE_FORMAT  = DateFormatter.dateFormat(
//                            fromTemplate: "yyyy年MM月dd日 HH時mm分",
//                            options: 0,
//                            locale: Locale(identifier: "ja_JP"))
//
//    let DATA_DATE_FORMAT  = DateFormatter.dateFormat(
//                            fromTemplate: "yMdkHms",
//                            options: 0,
//                            locale: Locale(identifier: "ja_JP"))

    
    
}
