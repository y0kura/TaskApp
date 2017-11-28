//
//  ViewController.swift
//  TaskApp
//
//  Created by 與倉利将 on 2017/11/23.
//  Copyright © 2017年 與倉利将. All rights reserved.
//

import UIKit
import PopupDialog

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var nvItem: UINavigationItem!
    
    let TASK_CONST = TaskConst()
    let userDefaults = UserDefaults.standard
    let FMT = DateFormatter()
    
    // タスク情報
    var taskArray = [TaskProperty]()
    // 表示データ
    var viewResultData = [TaskProperty]()
    // 表示カテゴリー
    var viewCategory = ""
    var viewDate = ""
    
    var filterList = [String]()
    var categoryList = [String]()
    
    var startDate:Date?
    var endDate:Date?
    
    /*******************************
     *  MARK: FormLoad
     *******************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 表示するデータのカテゴリーセット
        viewCategory = TASK_CONST.ALL
        nvItem.title = TASK_CONST.ALL
        
        filterList = TASK_CONST.FILTER_LIST
        categoryList = TASK_CONST.CATEGORY_LIST
        // "全て"追加
        filterList.append(TASK_CONST.ALL)
        categoryList.append(TASK_CONST.ALL)
        
        //バー背景色
//        self.navigationController?.navigationBar.barTintColor = UIColor.red
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // 日本語兼用の日付時刻のフォーマッタを設定
        FMT.locale = TASK_CONST.JA_LOCALE
        FMT.dateFormat = TASK_CONST.DATE_FORMAT
        
        /*******************************
         *  UITableView
         *******************************/
        // UITableViewへのリロード処理の追加
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.refreshControlValueChanged(sender:)), for: .valueChanged)
        refreshControl.addTarget(self, action: #selector(ViewController.refreshControlEndRefreshing(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        
        /*******************************
         *  UISearchBar
         *******************************/
        //デリゲート先を自分に設定する。
        searchBar.delegate = self
        //何も入力されていなくてもReturnキーを押せるようにする。
        searchBar.enablesReturnKeyAutomatically = false
        //表示データにTaskデータをコピーする。
        viewResultData = taskArray
        
    }

    /*******************************
     *  MARK: 再度読込イベント
     *******************************/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableReload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /*******************************
     *  MARK: タスク追加ボタン押下イベント
     *******************************/
    @IBAction func addTaskTap(_ sender: Any) {
        
        // ポップアップに表示したいビューコントローラー
        let vc = AddTaskViewController(nibName: "AddTaskViewController", bundle: nil)
        
        // 表示したいビューコントローラーを指定してポップアップを作る
        let popup = PopupDialog(viewController: vc)
        
        // 作成したポップアップを表示する
        present(popup, animated: true, completion: nil)
    }
    
    /*******************************
     *  MARK: tableView
     *******************************/
    // テーブルを下に引っ張った時
    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
        
        tableReload()
    }
    // インジケータを非表示
    @objc func refreshControlEndRefreshing(sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.endRefreshing()
        })
    }
    // MARK: テーブル再読み込み処理
    func tableReload(){
        
        taskArray.removeAll()
        //前回の保存内容があるかどうかを判定
        if((userDefaults.object(forKey: TASK_CONST.FOR_KEY)) != nil){
            // 保存されているデータ取得
            if let storedData = userDefaults.object(forKey: TASK_CONST.FOR_KEY) as? Data{
                
                let unarchivedData = NSKeyedUnarchiver.unarchiveObject(with: storedData) as? [TaskProperty];()
                for taskRecord in unarchivedData!{
                    taskArray.append(taskRecord)
                }
            }
        }
        viewUpdata()
        tableView.reloadData()
    }
    
    // セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの中のセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return viewResultData.count
    }
    
    // セル関連
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = taskArray[getRowTaskArray(array: viewResultData,index: indexPath.row)].task
        
        return cell
    }
    
    // セルタップ時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        pupupView(index: getRowTaskArray(array: viewResultData,index: indexPath.row))
    }
    
    // AddTaskポップアップ処理
    func pupupView(index:Int){
        
        // ポップアップに表示したいビューコントローラー
        let vc = AddTaskViewController(nibName: "AddTaskViewController", bundle: nil)
        vc.task = taskArray[index].task!
        vc.category = taskArray[index].category!
        if taskArray[index].date != nil{
            vc.date = taskArray[index].date!
        }
        vc.isUpdata = true
        vc.updataRow = index
        // 表示したいビューコントローラーを指定してポップアップを作る
        let popup = PopupDialog(viewController: vc)
        // 作成したポップアップを表示する
        present(popup, animated: true, completion: nil)
        
    }
    
    // 削除処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            taskArray.remove(at: getRowTaskArray(array: viewResultData,index: indexPath.row))
            viewUpdata()
            
            // 削除後の配列を保存
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: taskArray)
            UserDefaults.standard.set(encodedData, forKey: TASK_CONST.FOR_KEY)
            
            // tableView更新
            tableView.reloadData()
        }
    }
    
    /*******************************
     *  MARK: searchBar
     *******************************/
    //検索ボタン押下時の呼び出しメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //キーボードを閉じる。
        searchBar.endEditing(true)
    }

    //テキスト変更時の呼び出しメソッド
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //検索結果配列を空にする。
        viewResultData.removeAll()
        if(searchBar.text == "") {
            
            //検索文字列が空の場合
            for data in taskArray {
                getData(data: data)
            }
            
        } else {
            
            //検索文字列とスコープを含むデータを検索結果配列に追加する。
            let search:String = searchBar.text!
            for data in taskArray {
                
                if (data.task?.contains(search))!{
                    getData(data: data)
                }
            }
        }
        //テーブルを再読み込みする。
        tableView.reloadData()
    }
    
    // MARK: viewResultData更新
    func viewUpdata(){
        
        viewResultData.removeAll()
        if(searchBar.text == "") {
            
            //検索文字列が空の場合
            for data in taskArray {
                getData(data: data)
            }
            
        } else {
            
            //検索文字列とスコープを含むデータを検索結果配列に追加する。
            let search:String = searchBar.text!
            for data in taskArray {
                
                if (data.task?.contains(search))!{
                    getData(data: data)
                }
            }
        }
    }
    // TaskArrayの行番取得
    func getRowTaskArray(array:[TaskProperty], index:Int) -> Int {
        
        var i:Int = 0
        for data in taskArray{
            if(data.task == viewResultData[index].task &&
                data.category == viewResultData[index].category &&
                data.date == viewResultData[index].date ){
                return i
            }
            i = i + 1
        }
        return i
    }
    
    // 表示データ取得
    func getData(data:TaskProperty){
        
        
        if viewDate != ""{
            // 絞込み:フィルター
            nvItem.title = viewDate
            getViewDaate(data: data)
        }else{
            if viewCategory == TASK_CONST.ALL{
                
                // 対象カテゴリー[ALL]
                viewResultData.append(data)
            }else if(viewCategory == data.category){
                
                // 対象カテゴリー[ALL以外]
                viewResultData.append(data)
            }
        }
        
    }

    // 期日で絞り込む
    private func getViewDaate(data:TaskProperty) {
        
        switch viewDate {
        case filterList[3]:
            // 期日無し
            if data.date == nil{
                viewResultData.append(data)
            }
        case filterList[4]:
            // 全て
            viewResultData.append(data)
        default:
            // 対象日付内
            if startDate! <= data.date! && data.date! <= endDate!{
                viewResultData.append(data)
            }
        }
    }
    
    
}

