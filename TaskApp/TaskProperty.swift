//
//  TaskProperty.swift
//  TaskApp
//
//  Created by 與倉利将 on 2017/11/23.
//  Copyright © 2017年 與倉利将. All rights reserved.
//

import UIKit

class TaskProperty: NSObject {

    var task: String
    var category: String
    var date: Date
    
    init(task: String, category: String ,date:Date) {
        self.task = task
        self.category = category
        self.date = date
    }
}
