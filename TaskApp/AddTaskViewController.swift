//
//  AddTaskViewController.swift
//  TaskApp
//
//  Created by 與倉利将 on 2017/11/23.
//  Copyright © 2017年 與倉利将. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {

    
    @IBOutlet var categoryPicker: UIPickerView!
    
    // カテゴリーリスト(debug)
    var categoryList = ["無し", "仕事", "プライベート"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*********************
         *  カテゴリー設定
         *********************/
        // プロトコルの設定
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        // はじめに表示する項目を指定
        categoryPicker.selectRow(0, inComponent: 0, animated: true)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
        // 選択時の処理
        print(categoryList[row])
    }
    
    
}
