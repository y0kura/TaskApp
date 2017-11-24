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
    
    // アラートを作成
    let alert = UIAlertController(
        title: "タスクが入力されていません",
        message: "",
        preferredStyle: .alert)
    
    // カテゴリーリスト(debug)
    var categoryList = ["無し", "仕事", "プライベート"]
    var task: String!
    var category: String!
    var date: Date!
    
    // タスク情報
    var taskProperty = [TaskProperty]()
    
    
    
    // MARK: FormLoad時
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        /*********************
         *  タスク設定
         *********************/
        taskTextField.delegate = self
        
        
        /*********************
         *  カテゴリー設定
         *********************/
        // プロトコルの設定
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        // はじめに表示する項目を指定
        categoryPicker.selectRow(0, inComponent: 0, animated: true)
        
        /*********************
         *  期日設定
         *********************/
        // テキストフィールドにDatePickerを表示する
        let datePicker = UIDatePicker()
        dateTextField.inputView = datePicker
        
        
        // 日本の日付表示形式にする
        datePicker.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /*********************
     *  MARK: AddTask押下時
     *********************/
    @IBAction func addTaskTap(_ sender: Any) {
        
        // 現在のタスク情報取得
        if UserDefaults.standard.object(forKey: "taskProperty") != nil{
            
            taskProperty = UserDefaults.standard.object(forKey: "taskProperty") as! [TaskProperty]
        }
        
        // アプリに保存する
        // textFiledのnilチェック
        if taskTextField.text == nil || taskTextField.text == ""{
            // アラート表示
            self.present(alert, animated: true, completion: nil)
            return
        }
        // タスクセット
        task = taskTextField.text!
        
//        date =  Date[dateTextField.text]
        
//        taskProperty.append(TaskProperty(
//                task:task
//              , category:category
//              , date:date)
//
//
//        array.append(textFiled.text!)
//        UserDefaults.standard.set(array, forKey: "array")
        
        // 画面を戻す
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    /*********************
     *  MARK: タスク
     *********************/
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
    
    /*********************
     *  MARK: カテゴリー
     *********************/
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
    
    /*********************
     *  MARK: 期日
     *********************/


}
