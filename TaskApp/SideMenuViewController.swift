//
//  SideMenuViewController.swift
//  TaskApp
//
//  Created by 與倉利将 on 2017/11/27.
//  Copyright © 2017年 與倉利将. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate {

    @IBOutlet var filterTableView: UITableView!
    @IBOutlet var categoryTableView: UITableView!
    
    let TASK_CONST = TaskConst()
    // タイムゾーンを言語設定にあわせる
    let FMT = DateFormatter()
    let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
    
    var filterList = [String]()
    var categoryList = [String]()
    
    // 表示する対象データ
    var viewCategory = ""
    var viewDate = ""
    var startDate: Date?
    var endDate: Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filterTableView.delegate = self
        filterTableView.dataSource = self
        filterTableView.isScrollEnabled = false
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.isScrollEnabled = false
        
        navigationController?.delegate = self
        
        filterList = TASK_CONST.FILTER_LIST
        categoryList = TASK_CONST.CATEGORY_LIST
        // "全て"追加
        filterList.append(TASK_CONST.ALL)
        categoryList.append(TASK_CONST.ALL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*******************************
     *  MARK: tableView
     *******************************/
    
    // セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの中のセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == filterTableView{
            return filterList.count
        }else{
            return categoryList.count
        }
        
    }
    
    // セル関連
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == filterTableView{
            // フィルターテーブル
            let filterCell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
            filterCell.textLabel?.text = filterList[indexPath.row]
            
            return filterCell
        }else{
            // カテゴリーテーブル
            let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
            categoryCell.textLabel?.text = categoryList[indexPath.row]
            
            return categoryCell
        }
    }
    
    // セルタップ時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if tableView == filterTableView{
            
            // フィルターテーブル
            startDate = calendar.date(bySettingHour: 0, minute: 00, second: 0, of: Date())! + (60 * 60 * 9)
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: Date())! + (60 * 60 * 9)
            
            switch filterList[indexPath.row] {
                
            case filterList[0]:
                // 今日
                viewDate =  filterList[0]
                
            case filterList[1]:
                // 明日
                viewDate =  filterList[1]
                startDate = startDate! + (60 * 60 * 24)
                endDate = endDate! + (60 * 60 * 24)
                
            case filterList[2]:
                // １週間以内
                viewDate =  filterList[2]
                endDate = endDate! + (60 * 60 * 24 * 7)
                
            case filterList[3]:
                // 期間無し
                viewDate =  filterList[3]
                
            case filterList[4]:
                // 全て
                viewDate =  filterList[4]
                
            default:
                viewDate =  filterList[1]
                
            }
        }else{
            // カテゴリーテーブル
            switch categoryList[indexPath.row] {
            case categoryList[0]:
                // 仕事
                viewCategory =  categoryList[0]
            case categoryList[1]:
                // プライベート
                viewCategory =  categoryList[1]
            case categoryList[2]:
                // カテゴリー無し
                viewCategory =  categoryList[2]
            default:
                // 全て
                viewCategory =  categoryList[3]
            }
            
        }
        
        // 画面を戻す
        self.navigationController?.popViewController(animated: true)
    }
    
    // UINavigationControllerDelegateのメソッド。遷移する直前の処理。
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 遷移先が、AViewControllerだったら……
        if let controller = viewController as? ViewController {
            // AViewControllerのプロパティvalueの値変更。
                
            controller.viewDate = viewDate
            controller.viewCategory = viewCategory
            controller.startDate = startDate
            controller.endDate = endDate
            controller.tableReload()
        }
    }
    

    
}
