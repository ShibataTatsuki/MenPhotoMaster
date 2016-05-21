//
//  CenterViewController.swift
//  MenPhotoMaster
//
//  Created by 柴田　樹希 on 2016/03/29.
//  Copyright © 2016年 柴田　樹希. All rights reserved.
//

import UIKit
import CoreLocation

class CenterViewController: UIViewController,UITextFieldDelegate{

    
    @IBOutlet var myTextField: UITextField!
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    //AppDelegateのインスタンスを取得_
    override func viewDidLoad() {
        super.viewDidLoad()

         myTextField.delegate = self
        
        self.getDate()
        let ima = self.getDate()
        appDelegate.mydate =  "Time： \(ima)"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     UITextFieldが編集された直後に呼ばれるデリゲートメソッド.
     */
    func textFieldDidBeginEditing(textField: UITextField){
        print("textFieldDidBeginEditing:" + textField.text!)
    }
    
    /*
     UITextFieldが編集終了する直前に呼ばれるデリゲートメソッド.
     */
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing:" + textField.text!)
        
        return true
    }
    
    /*
     改行ボタンが押された際に呼ばれるデリゲートメソッド.
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        textField.resignFirstResponder()
        return true
    }
    @IBAction func next(){
        appDelegate.mytext = myTextField.text!
        
    }
    func getDate()->NSString {
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") // ロケールの設定
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss" // 日付フォーマットの設定
        let thisDate = dateFormatter.stringFromDate(now)
        //println(dateFormatter.stringFromDate(NSDate()))
        return thisDate
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
    */

}
