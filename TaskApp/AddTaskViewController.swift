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
    
    var task: String = ""
    var category: String = ""
    var date: Date?
    
    var isUpdata = false
    var updataRow = 0
    
    // タスク情報
    var taskArray = [TaskProperty]()
    
    // 日付入力用
    let DATE_PICKER = UIDatePicker()
    

    // タイムゾーンを言語設定にあわせる
    let FMT = DateFormatter()
    
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
        
        /*******************************
         *  期日設定
         *******************************/
        // 日本語兼用の日付時刻のフォーマッタを設定
        FMT.locale = TASK_CONST.JA_LOCALE
        FMT.dateFormat = TASK_CONST.DATE_FORMAT
        
        // テキストフィールドにDatePickerを表示する
        dateTextField.inputView = DATE_PICKER
        // 日本の日付表示形式にするaleIdentifier: "ja_JP") as Locale
        DATE_PICKER.locale = TASK_CONST.JA_LOCALE
        //回されるたびにupdateStrメソッドが呼ばれるようにする
        DATE_PICKER.addTarget(self, action: #selector(updateStr), for: .valueChanged)
        
        // 更新or新規
        if isUpdata{
            setFirstView()
            
        }else{
            categoryPicker.selectRow(0, inComponent: 0, animated: true)
            category = TASK_CONST.CATEGORY_LIST[0]
        }
        
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
        if dateTextField.text != nil && dateTextField.text != ""{
            
            date = self.DATE_PICKER.date + (60 * 60 * 9)
        }
        
        if (isUpdata) {
            taskArray.remove(at: updataRow)
        }
        // タスクプロパティにセット
        if date != nil {
            
            taskArray.append(TaskProperty(
                task:task,
                category:category,
                date:date!))
        }else{
            
            taskArray.append(TaskProperty(
                task:task,
                category:category))
        }
        
        
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
    
    func setFirstView() {
        taskTextField.text = task
        if date != nil {
            
            dateTextField.text = FMT.string(from: date! - (60 * 60 * 9))
        }
        var i = 0
        for str in TASK_CONST.CATEGORY_LIST{
            if str == category{
                categoryPicker.selectRow(i, inComponent: 0, animated: true)
            }
            i = i + 1
        }
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
        return TASK_CONST.CATEGORY_LIST.count
    }
    
    // UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 表示する文字列を返す
        return TASK_CONST.CATEGORY_LIST[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 値をセット
        category = TASK_CONST.CATEGORY_LIST[row]
    }
    
    /*******************************
     *  MARK: 期日
     *******************************/
    // 日付が変更された時
    @objc func updateStr() {
        
        dateTextField.text = FMT.string(from:self.DATE_PICKER.date)
    }

}
