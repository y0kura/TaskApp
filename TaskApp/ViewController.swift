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

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: タスク追加ボタン押下イベント
    @IBAction func addTaskTap(_ sender: Any) {
        
        // ポップアップに表示したいビューコントローラー
        let vc = AddTaskViewController(nibName: "AddTaskViewController", bundle: nil)
        
        // 表示したいビューコントローラーを指定してポップアップを作る
        let popup = PopupDialog(viewController: vc)
        
        // 作成したポップアップを表示する
        present(popup, animated: true, completion: nil)
    }
    
}

