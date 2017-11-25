//
//  TaskProperty.swift
//  TaskApp
//
//  Created by 與倉利将 on 2017/11/23.
//  Copyright © 2017年 與倉利将. All rights reserved.
//

import UIKit

class TaskProperty: NSObject ,NSCoding{
    
    var task: String?
    var category: String?
    var date: Date?
    
    //シリアライズ
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(task, forKey: "data1_key")
        aCoder.encode(category, forKey: "data2_key")
        aCoder.encode(date, forKey: "data3_key")
    }
    //デシリアライズ
//    required init(coder: NSCoder) {
//
//        self.task = coder.decodeObject(forKey: "data1_key") as? String
//        self.category = coder.decodeObject(forKey: "data2_key") as? String
//        self.date = coder.decodeObject(forKey: "data3_key") as? Date
//    }
    
    required init(coder aDecoder: NSCoder) {
        self.task = aDecoder.decodeObject(forKey: "data1_key") as? String
        self.category = aDecoder.decodeObject(forKey: "data2_key") as? String
        self.date = aDecoder.decodeObject(forKey: "data3_key") as? Date
    }

    
    init(task: String, category: String ,date:Date) {
        self.task = task
        self.category = category
        self.date = date
    }
    
}
