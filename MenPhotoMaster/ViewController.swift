//
//  ViewController.swift
//  MenPhotoMaster
//
//  Created by 柴田　樹希 on 2016/03/28.
//  Copyright © 2016年 柴田　樹希. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet var setumeiLabel: UILabel!
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    //AppDelegateのインスタンスを取得_
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.selectButtonTapped()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func presentPickerController(sourceType:UIImagePickerControllerSourceType){
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            self.presentViewController(picker,animated: true, completion: nil)
        }
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self .dismissViewControllerAnimated(true, completion: nil)
        
        photoImageView.image = image
    }
    
    @IBAction func selctButtonTapped(sender: UIButton){
        //    func sselectButtonTapped(){
        self.setumeiLabel.hidden = true
        
        let alertController = UIAlertController(title: "画像の取得先を選択", message: nil, preferredStyle: .ActionSheet)
        let firstAction = UIAlertAction(title: "カメラ", style: .Default){
            action in
            self.presentPickerController(.Camera)
        }
        let secondAction = UIAlertAction(title: "アルバム", style: .Default){
            action in
            self.presentPickerController(.PhotoLibrary)
        }
        


        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func drawText(image: UIImage) -> UIImage {
        let text = appDelegate.mytext
        let datetext = appDelegate.mydate
        UIGraphicsBeginImageContext(image.size)
        image.drawInRect(CGRectMake(0,0,image.size.width,image.size.height ))
        
        let textRect = CGRectMake(0,image.size.height/2-10,image.size.width, image.size.height - 5)
        let style = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        style.alignment = NSTextAlignment.Center
        let textFontAttributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(100),
            NSForegroundColorAttributeName: UIColor.redColor(),
            NSParagraphStyleAttributeName:style,
            NSBackgroundColorAttributeName:UIColor.blackColor().colorWithAlphaComponent(0.8)
        ]
        
        let textRect2 = CGRectMake(image.size.width/5,image.size.height*10/11,image.size.width, image.size.height - 5)
        let style2 = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        style2.alignment = NSTextAlignment.Center
        let text2FontAttributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(50),
            NSForegroundColorAttributeName: UIColor.redColor(),
            NSParagraphStyleAttributeName:style,
            NSBackgroundColorAttributeName:UIColor.blackColor().colorWithAlphaComponent(0.8)
        ]
        
        text.drawInRect(textRect, withAttributes: textFontAttributes)
        datetext.drawInRect(textRect2, withAttributes: text2FontAttributes)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
        
    }
    func drawMaskImage(image: UIImage)->UIImage{
        UIGraphicsBeginImageContext(image.size)
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        let maskImage = UIImage(named: "maruta")
        
        let offset: CGFloat = 50.0
        let maskRect = CGRectMake(
            image.size.width - maskImage!.size.width - offset,
            image.size.height - maskImage!.size.height - offset,
            maskImage!.size.width,
            maskImage!.size.height)
        
        maskImage!.drawInRect(maskRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    func simpleAlert(titleString: String){
        let alertController = UIAlertController(title: titleString, message: nil, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated:true , completion:nil )
    }
    @IBAction func processButtonTapped(sender: UIButton){
        guard let selectedPhoto = photoImageView.image else{
            simpleAlert("画像がありません")
            return
        }
        
        let alertController = UIAlertController(title: "合成するパーツを選択",message: nil, preferredStyle: .ActionSheet)
        let firstAction = UIAlertAction(title: "テキスト", style: .Default){
            action in
            self.photoImageView.image = self.drawText(selectedPhoto)
        }
        let secondAction = UIAlertAction(title:  "丸太", style: .Default){
            action in
            
            self.photoImageView.image = self.drawMaskImage(selectedPhoto)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController,animated: true, completion: nil)
    }
    func postToSNS(serviceType: String){
        let myComposeView = SLComposeViewController(forServiceType: serviceType)
        myComposeView.setInitialText("PhotoMasterからの投稿✨")
        myComposeView.addImage(photoImageView.image)
        self.presentViewController(myComposeView, animated: true, completion: nil)
    }
    @IBAction func uploadButtonTapped(sender: UIButton){
        guard let selectedPhoto = photoImageView.image else{
            simpleAlert("画像がありません")
            return
        }
        
        let alertController = UIAlertController(title: "アップロード先を選択", message: nil, preferredStyle: .ActionSheet)
        let firstAction = UIAlertAction(title: "Facebookに投稿", style: .Default){
            action in
            self.postToSNS(SLServiceTypeFacebook)
        }
        let secondAction = UIAlertAction(title: "twitterに投稿", style: .Default){
            action in
            self.postToSNS(SLServiceTypeTwitter)
        }
        let thirdAction = UIAlertAction(title: "カメラロールに保存", style: .Default){
            action in
            UIImageWriteToSavedPhotosAlbum(selectedPhoto,self,nil,nil)
            self.simpleAlert("アルバムに保存されました。")
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(thirdAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func onClickMyButton(sender: UIButton){
        guard let selectedPhoto = photoImageView.image else{
            simpleAlert("画像がありません")
            return
        }
//        let mySepiaFilter = CIFilter(name: "CISepiaTone")
//        mySepiaFilter!.setValue(photoImageView.image, forKey: kCIInputImageKey)
//        mySepiaFilter!.setValue(1.0, forKey: kCIInputIntensityKey)
//        let myOutputImage : CIImage = mySepiaFilter!.outputImage?

        
        // image が 元画像のUIImage
        let ciImage:CIImage = CIImage(image:photoImageView.image!)!
        let ciFilter:CIFilter = CIFilter(name: "CISepiaTone")!
        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
        ciFilter.setValue(0.8, forKey: "inputIntensity")
        let ciContext:CIContext = CIContext(options: nil)
        let cgimg:CGImageRef = ciContext.createCGImage(ciFilter.outputImage!, fromRect:ciFilter.outputImage!.extent)
        
        
        //image2に加工後のUIImage
        let image2:UIImage? = UIImage(CGImage: cgimg, scale: 1.0, orientation:UIImageOrientation.Up)
        photoImageView.image = image2
        photoImageView.setNeedsDisplay()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


