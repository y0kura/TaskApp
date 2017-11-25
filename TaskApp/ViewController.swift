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
    
    
    let TASK_CONST = TaskConst()
    let userDefaults = UserDefaults.standard
    
    // タスク情報
    var taskArray = [TaskProperty]()
    
    //検索結果配列
    var searchResult = [TaskProperty]()
    
    // 表示ターゲット
    var viewTarget = ""
    
    /*******************************
     *  MARK: FormLoad
     *******************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTarget = TASK_CONST.ALL
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
        //検索結果配列にデータをコピーする。
        searchResult = taskArray
        
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
        serchUpdata()
        tableView.reloadData()
    }
    
    // セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの中のセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 動的に処理
        switch viewTarget {
            
        case TASK_CONST.ALL:
            return taskArray.count
            
        case TASK_CONST.SEARCH:
            return searchResult.count
            
        default:
            return taskArray.count
        }
    }
    
    // セル関連
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        switch viewTarget {
            
        case TASK_CONST.ALL:
            
            cell.textLabel?.text = taskArray[indexPath.row].task
            
        case TASK_CONST.SEARCH:
            
            var i = 0
            for data in taskArray{
                if(data.task == searchResult[indexPath.row].task &&
                   data.category == searchResult[indexPath.row].category &&
                   data.date == searchResult[indexPath.row].date ){
    
                    cell.textLabel?.text = taskArray[i].task
                }
                i = i + 1
            }
        
        default:
            
            cell.textLabel?.text = taskArray[indexPath.row].task
        }
        
        return cell
    }
    
    // セルタップ時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        switch viewTarget {
        case TASK_CONST.ALL:
            
            pupupView(index: indexPath.row)
            
        case TASK_CONST.SEARCH:
            
            pupupView(index: getRowTaskArray(array: searchResult,index: indexPath.row))
            
        default:
            pupupView(index: indexPath.row)
        }
    }
    
    // AddTaskポップアップ処理
    func pupupView(index:Int){
        
        // ポップアップに表示したいビューコントローラー
        let vc = AddTaskViewController(nibName: "AddTaskViewController", bundle: nil)
        vc.task = taskArray[index].task!
        vc.category = taskArray[index].category!
        vc.date = taskArray[index].date!
        vc.updataFlg = true
        vc.updataRow = index
        // 表示したいビューコントローラーを指定してポップアップを作る
        let popup = PopupDialog(viewController: vc)
        // 作成したポップアップを表示する
        present(popup, animated: true, completion: nil)
        
    }
    
    // 削除処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            
            switch viewTarget {
                
            case TASK_CONST.ALL:
                // 対象セルのデータを配列から削除
                taskArray.remove(at: indexPath.row)
                
            case TASK_CONST.SEARCH:
                
//                var i = 0
//                for data in taskArray{
//                    if(data.task == searchResult[indexPath.row].task &&
//                        data.category == searchResult[indexPath.row].category &&
//                        data.date == searchResult[indexPath.row].date ){
//
//                        taskArray.remove(at: i)
//                    }
//                    i = i + 1
//                }
                taskArray.remove(at: getRowTaskArray(array: searchResult,index: indexPath.row))
                serchUpdata()
                
            default:
                taskArray.remove(at: indexPath.row)
            }
            
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
        searchResult.removeAll()

        if(searchBar.text == "") {
            //検索文字列が空の場合はすべてを表示する。
            viewTarget = TASK_CONST.ALL
        } else {
            viewTarget = TASK_CONST.SEARCH
            //検索文字列とスコープを含むデータを検索結果配列に追加する。
            for data in taskArray {
                if (data.task?.contains(searchText))!{
                    searchResult.append(data)
                }
            }
        }
        //テーブルを再読み込みする。
        tableView.reloadData()
    }
    
    // MARK: searchResultUpData
    func serchUpdata(){
        
        searchResult.removeAll()
        if(searchBar.text == "") {
            //検索文字列が空の場合はすべてを表示する。
            viewTarget = TASK_CONST.ALL
        } else {
            
            viewTarget = TASK_CONST.SEARCH
            //検索文字列とスコープを含むデータを検索結果配列に追加する。
            let search:String = searchBar.text!
            for data in taskArray {
                if (data.task?.contains(search))!{
                    searchResult.append(data)
                }
            }
        }
    }
    // TaskArrayの行番取得
    func getRowTaskArray(array:[TaskProperty], index:Int) -> Int {
        
        var i:Int = 0
        for data in taskArray{
            if(data.task == searchResult[index].task &&
                data.category == searchResult[index].category &&
                data.date == searchResult[index].date ){
                return i
            }
            i = i + 1
        }
        return i
    }
}

