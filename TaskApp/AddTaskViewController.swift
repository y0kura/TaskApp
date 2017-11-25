//
//  AddTaskViewController.swift
//  TaskApp
//
//  Created by 與倉利将 on 2017/11/23.
//  Copyright © 2017年 與倉利将. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    @IBOutlet var taskTextField: UITextField!
    @IBOutlet var categoryPicker: UIPickerView!
    @IBOutlet var dateTextField: UITextField!
    
    let TASK_CONST = TaskConst()
    
    // アラートを作成
    let ALERT1 = UIAlertController(
        title: "タスクが入力されていません",
        message: "",
        preferredStyle: .alert)
    let ALERT2 = UIAlertController(
        title: "日付が変換できません",
        message: "",
        preferredStyle: .alert)
    
    // カテゴリーリスト(debug)
    var categoryList = ["無し", "仕事", "プライベート"]
    var task: String = ""
    var category: String = ""
    var date: String = ""
    
    // タスク情報
    var taskArray = [TaskProperty]()
    
    // 日付入力用
    let DATE_PICKER = UIDatePicker()
    

    // タイムゾーンを言語設定にあわせる
    let FMT = DateFormatter()
    let JA_LOCALE = Locale(identifier: "ja_JP")
    
    
    let userDefaults = UserDefaults.standard

    // MARK: FormLoad時
    override func viewDidLoad() {
        super.viewDidLoad()

        // アラートにボタンをつける
        ALERT1.addAction(UIAlertAction(title: "OK", style: .default))
        
        /*******************************
         *  タスク設定
         *******************************/
        taskTextField.delegate = self
        
        
        /*******************************
         *  カテゴリー設定
         *******************************/
        // プロトコルの設定
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        // はじめに表示する項目を指定
        categoryPicker.selectRow(0, inComponent: 0, animated: true)
        category = categoryList[0]
        
        /*******************************
         *  期日設定
         *******************************/
        
        
        // 日本語兼用の日付時刻のフォーマッタを設定
        FMT.locale = JA_LOCALE
        FMT.dateFormat = "yyyy年MM月dd日 HH時mm分"
        
        // テキストフィールドにDatePickerを表示する
        dateTextField.inputView = DATE_PICKER
        
        // 日本の日付表示形式にする
        DATE_PICKER.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        
        //回されるたびにupdateStrメソッドが呼ばれるようにする
        DATE_PICKER.addTarget(self, action: #selector(updateStr), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /*******************************
     *  MARK: AddTask押下時
     *******************************/
    @IBAction func addTaskTap(_ sender: Any) {
        
        //前回の保存内容があるかどうかを判定
        if((userDefaults.object(forKey: TASK_CONST.FOR_KEY)) != nil){
            
            // 保存されているデータ取得
            if let storedData = userDefaults.object(forKey: TASK_CONST.FOR_KEY) as? Data{

                let unarchivedData = NSKeyedUnarchiver.unarchiveObject(with: storedData) as? [TaskProperty];()
                var taskRecord:TaskProperty
                for taskRecord in unarchivedData!{
                    taskArray.append(taskRecord)
                }
            }
        }
        
        // textFiledのnilチェック
        if taskTextField.text == nil || taskTextField.text == ""{
            // アラート表示
            self.present(ALERT1, animated: true, completion: nil)
            return
        }
        // タスクセット
        task = taskTextField.text!
        // 期日セット
        if (dateTextField.text != nil) {
            date = dateTextField.text!
        }
        // タスクプロパティにセット
        taskArray.append(TaskProperty(task:task,category:category,date:date))
        
        //保存
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: taskArray)
        UserDefaults.standard.set(encodedData, forKey: TASK_CONST.FOR_KEY)
        
        // 画面を戻す
        self.dismiss(animated: true, completion: nil)
        
    }
    /*******************************
     *  MARK: CloseTask押下時
     *******************************/
    @IBAction func closeTaskTap(_ sender: Any) {
        // 画面を戻す
        self.dismiss(animated: true, completion: nil)
    }
    
    /*******************************
     *  MARK: タスク
     *******************************/
    //MARK: returnキー押下時
    func textFieldShouldReturn(_ taskTextField: UITextField) -> Bool {
        // キーボードを閉じる
        taskTextField.resignFirstResponder()
        return true
    }
    //MARK: textFiled以外押下時
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    /*******************************
     *  MARK: カテゴリー
     *******************************/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // 表示する列数
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // アイテム表示個数を返す
        return categoryList.count
    }
    
    // UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 表示する文字列を返す
        return categoryList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 値をセット
        category = categoryList[row]
    }
    
    /*******************************
     *  MARK: 期日
     *******************************/
    // 日付が変更された時
    @objc func updateStr() {
        
        if FMT.date(from: FMT.string(from:self.DATE_PICKER.date)) != nil {
            
            dateTextField.text = FMT.string(from:self.DATE_PICKER.date)
        } else {
            // アラート表示
            self.present(ALERT2, animated: true, completion: nil)
            return
        }
    }

}
