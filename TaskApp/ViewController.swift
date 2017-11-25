//
//  ViewController.swift
//  TaskApp
//
//  Created by 與倉利将 on 2017/11/23.
//  Copyright © 2017年 與倉利将. All rights reserved.
//

import UIKit
import PopupDialog

class ViewController: UIViewController {

    
    @IBOutlet var tableView: UITableView!
    
    
    let TASK_CONST = TaskConst()
    
    // タスク情報
    var taskArray:[TaskProperty] = [TaskProperty]()
    
    /*********************
     *  MARK: FormLoad
     *********************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
            UserDefaults.standard.removeObject(forKey: TASK_CONST.FOR_KEY)

    }

    /*********************
     *  MARK: 再度読込イベント
     *********************/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // アプリ内で保存された配列を取り出す
        if UserDefaults.standard.object(forKey: TASK_CONST.FOR_KEY) != nil{
            
            taskArray = UserDefaults.standard.object(forKey: TASK_CONST.FOR_KEY) as! [TaskProperty]
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    /*********************
     *  MARK: タスク追加ボタン押下イベント
     *********************/
    @IBAction func addTaskTap(_ sender: Any) {
        
        // ポップアップに表示したいビューコントローラー
        let vc = AddTaskViewController(nibName: "AddTaskViewController", bundle: nil)
        
        // 表示したいビューコントローラーを指定してポップアップを作る
        let popup = PopupDialog(viewController: vc)
        
        // 作成したポップアップを表示する
        present(popup, animated: true, completion: nil)
    }
    
    /*********************
     *  MARK: tableView
     *********************/
    // セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの中のセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 動的に処理
        return taskArray.count
    }
    
    // セル関連
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = taskArray[indexPath.row].task
        
        return cell
    }
    
    // 削除処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            // 対象セルのデータを配列から削除
            taskArray.remove(at: indexPath.row)
            
            // 削除後の配列を保存
            UserDefaults.standard.set(taskArray, forKey: TASK_CONST.FOR_KEY)
            
            // tableView更新
            tableView.reloadData()
        }
    }
    
}

