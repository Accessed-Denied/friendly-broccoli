//
//  Utility.swift
//  EASY
//
//  Created by Rohit Saini on 13/01/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import Foundation
import UIKit
import Toaster
import Firebase


let pickerAnimationDuration: TimeInterval = 0.3
let viewTransperantTag: Int = 9099
let pickerHeight: CGFloat = 216

class RPicker: NSObject {
    
    static private let sharedInstance = RPicker()
    private var dataArray: Array<String> = []
    
    class func selectDate(title: String = "",
                          hideCancel: Bool = false,
                          datePickerMode: UIDatePicker.Mode = .date,
                          selectedDate: Date? = Date(),
                          minDate: Date? = nil,
                          maxDate: Date? = nil,
                          didSelectDate : ((_ date: Date)->())?)  {
        
        if let currentController = UIWindow.currentController {
            
            if let _ = currentController.view.viewWithTag(viewTransperantTag) {
                return
            }
            
            //hide keyboard
            UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
            
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = datePickerMode
            datePicker.backgroundColor = UIColor.white
            
            datePicker.minimumDate = minDate
            datePicker.maximumDate = maxDate
            
            if let selectedDate = selectedDate {
                datePicker.date = selectedDate
            } else {
                datePicker.date = Date()
            }
            
            //Screen Size
            let screenWidth = currentController.view.bounds.size.width
            let screenHeight = currentController.view.bounds.size.height
            
            // Add background view
            
            let closeFrame = CGRect(x: 0, y: screenHeight + 50, width: screenWidth, height: screenHeight)
            
            let viewTransperant = UIView()
            let view = currentController.view
            
            //viewTransperant.alpha = 0.0
            view?.addSubview(viewTransperant)
            viewTransperant.tag = viewTransperantTag
            view?.addBGViewConstraints(viewTransperant)
            
            // Add date picker view
            
            viewTransperant.addSubview(datePicker)
            viewTransperant.addPickerViewConstraints(datePicker)
            
            // Add tool bar with done and cancel buttons
            
            let toolBar = RToolBar()
            viewTransperant.addSubview(toolBar)
            viewTransperant.addToolBarConstraints(toolBar, -pickerHeight)
            toolBar.addToolBar(hideCancelButton: hideCancel)
            toolBar.title = title
            
            // show picker
            var openPickerFrame = viewTransperant.frame
            openPickerFrame.origin.y = 0
            
            UIView.animate(withDuration: pickerAnimationDuration, animations: {
                viewTransperant.frame = openPickerFrame
                
            }, completion: { (_) in
                UIView.animate(withDuration: pickerAnimationDuration, animations: {
                    viewTransperant.backgroundColor = UIColor(red: (0/255.0), green: (0/255.0), blue: (0/255.0), alpha: 0.6)
                })
            })
            
            toolBar.didSelectDone = {
                didSelectDate!(datePicker.date)
                remove()
            }
            
            toolBar.didCancelled = {
                
                remove()
            }
            
            func remove() {
                
                UIView.animate(withDuration: pickerAnimationDuration, animations: {
                    viewTransperant.backgroundColor = UIColor.clear
                    
                }, completion: { (_) in
                    UIView.animate(withDuration: pickerAnimationDuration, animations: {
                        viewTransperant.frame = closeFrame
                    }, completion: { (_) in
                        viewTransperant.removeFromSuperview()
                    })
                })
            }
        }
    }
    
    class func selectOption(title: String = "",
                            hideCancel: Bool = false,
                            dataArray:Array<String>?,
                            selectedIndex: Int? = nil,
                            didSelectValue : ((_ value: String, _ atIndex: Int)->())?)  {
        
        guard let dataArray = dataArray else {
            print("Blank array")
            return
        }
        
        let picker = RPicker.sharedInstance
        
        picker.dataArray = dataArray
        
        if let currentController = UIWindow.currentController {
            
            if let bgView = currentController.view.viewWithTag(viewTransperantTag) {
                return
            }
            
            //hide keyboard
            UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
            
            let optionPicker = UIPickerView()
            optionPicker.backgroundColor = UIColor.white
            optionPicker.dataSource = picker
            optionPicker.delegate = picker
            
            if let selectedIndex = selectedIndex {
                
                if (selectedIndex < dataArray.count) {
                    optionPicker.selectRow(selectedIndex, inComponent: 0, animated: false)
                }
            }
            
            //Screen Size
            let screenWidth = currentController.view.bounds.size.width
            let screenHeight = currentController.view.bounds.size.height
            let pickerHeight: CGFloat = 216
            
            // Add background view
            
            let closeFrame = CGRect(x: 0, y: screenHeight + 50, width: screenWidth, height: screenHeight)
            
            let viewTransperant = UIView()
            
            
            //viewTransperant.alpha = 0.0
            currentController.view.addSubview(viewTransperant)
            let view = currentController.view
            viewTransperant.tag = viewTransperantTag
            view?.addBGViewConstraints(viewTransperant)
            
            // Add date picker view
            
            viewTransperant.addSubview(optionPicker)
            viewTransperant.addPickerViewConstraints(optionPicker)
            
            // Add tool bar with done and cancel buttons
            
            let toolBar = RToolBar()
            viewTransperant.addSubview(toolBar)
            viewTransperant.addToolBarConstraints(toolBar, -pickerHeight)
            toolBar.addToolBar(hideCancelButton: hideCancel)
            toolBar.title = title
            
            // show picker
            var openPickerFrame = viewTransperant.frame
            openPickerFrame.origin.y = 0
            
            UIView.animate(withDuration: pickerAnimationDuration, animations: {
                viewTransperant.frame = openPickerFrame
                
            }, completion: { (_) in
                UIView.animate(withDuration: pickerAnimationDuration, animations: {
                    viewTransperant.backgroundColor = UIColor(red: (0/255.0), green: (0/255.0), blue: (0/255.0), alpha: 0.6)
                })
            })
            
            toolBar.didSelectDone = {
                
                if let block = didSelectValue {
                    
                    let selectedValueIndex = optionPicker.selectedRow(inComponent: 0)
                    
                    block(dataArray[selectedValueIndex], selectedValueIndex)
                }
                remove()
            }
            
            toolBar.didCancelled = {
                
                remove()
            }
            
            func remove() {
                
                UIView.animate(withDuration: pickerAnimationDuration, animations: {
                    viewTransperant.backgroundColor = UIColor.clear
                    
                }, completion: { (_) in
                    UIView.animate(withDuration: pickerAnimationDuration, animations: {
                        viewTransperant.frame = closeFrame
                    }, completion: { (_) in
                        viewTransperant.removeFromSuperview()
                    })
                })
            }
        }
    }
}

extension RPicker: UIPickerViewDataSource, UIPickerViewDelegate {
    
    //function for the number of columns in the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //function counting the array to give the number of rows in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    //function displaying the array rows in the picker as a string
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataArray[row]
    }
}

class RToolBar: UIView {
    
    open var didSelectDone: (() -> Void)?
    open var didCancelled: (() -> Void)?
    
    var toolBarTitleItem: ToolBarTitleItem?
    
    private var hideCancelButton: Bool = false
    
    var title = "" {
        didSet {
            guard let toolBarTitleItem = toolBarTitleItem else {
                return
            }
            
            toolBarTitleItem.label.text = title
        }
    }
    
    func addToolBar(hideCancelButton: Bool = false) {
        self.hideCancelButton = hideCancelButton
        let toolbarL = toolbar
        self.addSubview(toolbarL)
        self.addToolBarConstraints(toolbarL)
    }
    
    open var toolbar: UIToolbar {
        
        let toolBarL = ToolBar(frame: frame, target: self)
        
        if !hideCancelButton {
            toolBarL.appendButton(buttonItem: toolBarL.buttonItem(systemItem: .cancel, selector: #selector(self.cancelAction)))
        }
        
        //toolBar.appendButton(buttonItem: toolBar.buttonItem(systemItem: .camera, selector: #selector(self.doneAction)))
        toolBarL.appendButton(buttonItem: toolBarL.flexibleSpace)
        
        let toolBarTitleItem = toolBarL.titleItem(text: "", font: UIFont(name: "HelveticaNeue-Medium", size: 15.0)!, color: UIColor.black)
        
        self.toolBarTitleItem = toolBarTitleItem as? ToolBarTitleItem
        toolBarL.appendButton(buttonItem: toolBarTitleItem)
        toolBarL.appendButton(buttonItem: toolBarL.flexibleSpace)
        toolBarL.appendButton(buttonItem: toolBarL.buttonItem(systemItem: .done, selector: #selector(self.doneAction)))
        
        return toolBarL
    }
    
    @objc func doneAction() {
        didSelectDone?()
    }
    
    @objc func cancelAction() {
        
        if !hideCancelButton {
            didCancelled?()
        }
    }
}

class ToolBar: UIToolbar {
    
    let target: Any?
    
    init(frame: CGRect, target: Any?) {
        self.target = target
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonItem(systemItem: UIBarButtonItem.SystemItem, selector: Selector?) -> UIBarButtonItem {
        
        return UIBarButtonItem(barButtonSystemItem: systemItem, target: target, action: selector)
    }
    
    var flexibleSpace: UIBarButtonItem {
        return buttonItem(systemItem: UIBarButtonItem.SystemItem.flexibleSpace, selector:nil)
    }
    
    func titleItem (text: String, font: UIFont, color: UIColor) -> UIBarButtonItem {
        return ToolBarTitleItem(text: text, font: font, color: color)
    }
    
    func appendButton(buttonItem: UIBarButtonItem) {
        if items == nil {
            items = [UIBarButtonItem]()
        }
        
        buttonItem.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 14.0)!,
            NSAttributedString.Key.foregroundColor: UIColor(red: (49/255.0), green: (118/255.0), blue: 239, alpha: 1)],
                                          for: .normal)
        
        items!.append(buttonItem)
    }
}

class ToolBarTitleItem: UIBarButtonItem {
    
    var label: UILabel
    
    init(text: String, font: UIFont, color: UIColor) {
        
        var frame = UIScreen.main.bounds
        frame.size.width = UIScreen.main.bounds.width - 140
        
        label =  UILabel(frame: frame)
        label.text = text
        //label.sizeToFit()
        label.font = font
        label.textColor = color
        label.textAlignment = .center
        label.numberOfLines = 0
        
        super.init()
        
        customView = label
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIWindow {
    
    static var currentController: UIViewController? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.window?.currentController
    }
    
    var currentController: UIViewController? {
        if let vc = self.rootViewController {
            return topViewController(controller: vc)
        }
        return nil
    }
    
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nc = controller as? UINavigationController {
            if nc.viewControllers.count > 0 {
                return topViewController(controller: nc.viewControllers.last!)
            } else {
                return nc
            }
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIView {
    
    func addBGViewConstraints(_ relativeToView: UIView) {
        
        relativeToView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: relativeToView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: relativeToView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: relativeToView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: relativeToView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0)
        self.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    func addPickerViewConstraints(_ relativeToView: UIView) {
        
        relativeToView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: relativeToView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: relativeToView, attribute: NSLayoutConstraint.Attribute.bottomMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: relativeToView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: relativeToView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: pickerHeight)
        self.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    func addToolBarConstraints(_ relativeToView: UIView,_ bottomConst: CGFloat = 0) {
        
        relativeToView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: relativeToView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: relativeToView, attribute: NSLayoutConstraint.Attribute.bottomMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1, constant: bottomConst)
        let widthConstraint = NSLayoutConstraint(item: relativeToView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: relativeToView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 48)
        self.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
        
        // Export pdf from Save pdf in drectory and return pdf file path
        func exportAsPdfFromView() -> String {
            
            let pdfPageFrame = self.bounds
            let pdfData = NSMutableData()
            UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
            UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
            guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
            self.layer.render(in: pdfContext)
            UIGraphicsEndPDFContext()
            return self.saveViewPdf(data: pdfData)
            
        }
        
        // Save pdf file in document directory
        func saveViewPdf(data: NSMutableData) -> String {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docDirectoryPath = paths[0]
            let pdfPath = docDirectoryPath.appendingPathComponent("viewPdf.pdf")
            if data.write(to: pdfPath, atomically: true) {
                return pdfPath.path
            } else {
                return ""
            }
        }
    
}


extension Date {
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateSaini(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        //dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}


//MARK:- getCurrentTimeStampValue
func getCurrentTimeStampValue() -> String
{
    return String(format: "%0.0f", Date().timeIntervalSince1970*1000)
}
//MARK:- showLoader
func showLoader()
{
    AppDelegate().sharedDelegate().showLoader()
}
//MARK:- removeLoader
func removeLoader()
{
    AppDelegate().sharedDelegate().removeLoader()
}

//MARK:- Toast
func displayToast(_ message:String)
{
    let toast = Toast(text: NSLocalizedString(message, comment: ""))
    toast.show()
}

func showAlertwithTitle(title:String , desc:String , vc:UIViewController)  {
    let alert = UIAlertController(title: title, message: desc, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    vc.present(alert, animated: true, completion: nil)
}

//Image Compression to 10th
func compressImage(image: UIImage) -> Data {
    // Reducing file size to a 10th
    
    var actualHeight : CGFloat = image.size.height
    var actualWidth : CGFloat = image.size.width
    let maxHeight : CGFloat = 1920.0
    let maxWidth : CGFloat = 1080.0
    var imgRatio : CGFloat = actualWidth/actualHeight
    let maxRatio : CGFloat = maxWidth/maxHeight
    var compressionQuality : CGFloat = 0.5
    
    if (actualHeight > maxHeight || actualWidth > maxWidth) {
        
        if (imgRatio < maxRatio) {
            
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        } else if (imgRatio > maxRatio) {
            
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
            
        } else {
            
            actualHeight = maxHeight
            actualWidth = maxWidth
            compressionQuality = 1
        }
    }
    
    let rect = CGRect(x: 0.0, y: 0.0, width:actualWidth, height:actualHeight)
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in: rect)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    let imageData = img!.jpegData(compressionQuality: compressionQuality)
    UIGraphicsEndImageContext();
    
    return imageData!
}

open class sainiCardView: UIView {

     @IBInspectable var cornerRadious : CGFloat = 5
     @IBInspectable var shadowColor : UIColor? = UIColor.black
     @IBInspectable let shadowOffSetWidth : Int = 0
     @IBInspectable let shadowOffSetHeight : Int =  1
     @IBInspectable var shadowOpacity : CGFloat = 0.2

     override open func layoutSubviews(){
        layer.cornerRadius = cornerRadious
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)

         let shadowpath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadious)
        layer.shadowPath =  shadowpath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
    }


 }


func getDifferenceFromCurrentTimeInHourInDays(_ timestamp : Double) -> String
{
    let interval : Int = getDifferenceFromCurrentTime(timestamp)
    
    let second : Int = interval
    let minutes : Int = interval/60
    let hours : Int = interval/(60*60)
    let days : Int = interval/(60*60*24)
    let week : Int = interval/(60*60*24*7)
    let months : Int = interval/(60*60*24*30)
    let years : Int = interval/(60*60*24*30*12)
    
    var timeAgo : String = ""
    if  second < 60
    {
        timeAgo = (second < 3) ? "Just Now" : (String(second) + "s")
    }
    else if minutes < 60
    {
        timeAgo = String(minutes) + "m"
    }
    else if hours < 24
    {
        timeAgo = String(hours) + "h"
    }
    else if days < 30
    {
        timeAgo = String(days) + " "  + ((days > 1) ? "days" : "day")
    }
    else if week < 4
    {
        timeAgo = String(week) + " "  + ((week > 1) ? "weeks" : "week")
    }
    else if months < 12
    {
        timeAgo = String(months) + " "  + ((months > 1) ? "months" : "month")
    }
    else
    {
        timeAgo = String(years) + " "  + ((years > 1) ? "years" : "year")
    }
    
    if second > 3 {
        timeAgo = timeAgo + " ago"
    }
    return timeAgo
}

//MARK: Date difference
func getDifferenceFromCurrentTime(_ timeStemp : Double) -> Int
{
    let newDate : Date = Date(timeIntervalSince1970: TimeInterval(timeStemp))
    let currentDate : Date = Date()
    let interval = currentDate.timeIntervalSince(newDate)
    return Int(interval)
}

func getReadableDate(timeStamp: TimeInterval) -> String? {
    let date = Date(timeIntervalSince1970: timeStamp)
    let dateFormatter = DateFormatter()
    
    if Calendar.current.isDateInTomorrow(date) {
        return "Tomorrow"
    } else if Calendar.current.isDateInYesterday(date) {
        return "Yesterday"
    } else if dateFallsInCurrentWeek(date: date) {
        if Calendar.current.isDateInToday(date) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        }
    } else {
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
}

func dateFallsInCurrentWeek(date: Date) -> Bool {
    let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
    let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
    return (currentWeek == datesWeek)
}

//MARK:- SainiProgressAlertView
 func sainiProgressAlertView(title:String,progress: Double ){
     let alertCtr = UIAlertController(title: title, message: "\(Int(progress))%", preferredStyle: .alert)
     alertCtr.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
         // Do things
     }))

     let alertView = alertCtr.view

     let progressView = UIProgressView(frame: CGRect.zero)
     progressView.progress = Float(progress)
     progressView.translatesAutoresizingMaskIntoConstraints = false
     alertView?.addSubview(progressView)


     let bottomConstraint  = progressView.bottomAnchor.constraint(equalTo: alertView!.bottomAnchor)
     bottomConstraint.isActive = true
     bottomConstraint.constant = -45 // How to constraint to Cancel button?

     
     progressView.leftAnchor.constraint(equalTo: alertView!.leftAnchor).isActive = true
     progressView.rightAnchor.constraint(equalTo: alertView!.rightAnchor).isActive = true

     UIViewController.top?.present(alertCtr, animated: true)
 }

extension UIView{
    //MARK: - sainiSaabBlur
    func sainiSaabBlur(blurValue:CGFloat){
        let visualEffectView = VisualEffectView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        
        // Configure the view with tint color, blur radius, etc
        visualEffectView.colorTint = .clear
        visualEffectView.colorTintAlpha = 0.2
        visualEffectView.blurRadius = blurValue
        visualEffectView.scale = 1
        self.addSubview(visualEffectView)
    }
}


enum DEVICE_TYPE: Int {
    case iPhone_6 = 667
    case iPhone_6_Plus = 847
//    case iPhone_6s = 667
//    case iPhone_6s_Plus = 847
    case iPhone_SE_1st_gen = 568
//    case iPhone_7 = 667
//    case iPhone_7_Plus = 847
//    case iPhone_8 = 667
    case iPhone_8_Plus = 736
    case iPhone_X = 812
//    case iPhone_XS = 812
    case iPhone_XS_Max = 896
//    case iPhone_XR = 896
//    case iPhone_11 = 896
//    case iPhone_11_Pro = 812
//    case iPhone_11_Pro_Max = 896
//    case iPhone_SE_2nd_gen = 667
    case iPhone_12 = 844
//    case iPhone_12_Pro = 844
    case iPhone_12_Pro_Max = 926
//    case iPhone_12_mini = 812
}
