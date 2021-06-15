//
//  AppDelegate.swift
//  EASY
//
//  Created by Rohit Saini on 06/01/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var activityLoader : NVActivityIndicatorView!
    var customTabbarVc : CustomTabBarController!

    //open a new Pipe to consume the messages on STDOUT and STDERR
    let inputPipe = Pipe()
    
    //open another Pipe to output messages back to STDOUT
    let outputPipe = Pipe()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        openConsolePipe()
        //Setup Firebase
        //==============
        FirebaseApp.configure()
        
        
        //End
        //===============
        
        //IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        AudioServiceObserver()
        checkAutoLogin()
        
        return true
    }
    
    //MARK:- Checks the Auto Login
    func checkAutoLogin(){
            guard let userId = UserDefaults.standard.value(forKey: "userId") as?  String else{
                return
            }
        if userId != ""{
          if let savedPerson = UserDefaults.standard.object(forKey: "currentUser") as? Data {
                let decoder = JSONDecoder()
                if let loadedPerson = try? decoder.decode(FirebaseUser.self, from: savedPerson) {
                    AppModel.shared.loggedInUser = loadedPerson
                }
            }
            self.navigateToDashboard()
        }
            
    }
    
    private func AudioServiceObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(ToggleSound(_ :)), name: NOTIFICATIONS.PlaySound, object: nil)
    }
    
    @objc func ToggleSound(_ notification: Notification){
        let data = notification.object as! [String: Bool]
        print(data)
        AppConstants.shouldPlaySound = data["data"]!
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if AppModel.shared.loggedInUser != nil{
        User.updateUserOnlineStatus(userId: AppModel.shared.loggedInUser.id, isOnline: false)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if AppModel.shared.loggedInUser != nil{
        User.updateUserOnlineStatus(userId: AppModel.shared.loggedInUser.id, isOnline: true)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    
    //MARK:- sharedDelegate
    func sharedDelegate() -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //MARK:- Show Loader
    func showLoader()
    {
        removeLoader()
        window?.isUserInteractionEnabled = false
        activityLoader = NVActivityIndicatorView(frame: CGRect(x: ((window?.frame.size.width)!-50)/2, y: ((window?.frame.size.height)!-50)/2, width: 50, height: 50))
        activityLoader.type = .ballPulseSync
        activityLoader.color = colorFromHex(hex: "#FF5936")
        window?.addSubview(activityLoader)
        activityLoader.startAnimating()
    }
    
    //MARK:- Remove Loader
    func removeLoader()
    {
        
        window?.isUserInteractionEnabled = true
        if activityLoader == nil
        {
            return
        }
        activityLoader.stopAnimating()
        activityLoader.removeFromSuperview()
        activityLoader = nil
    }
    
    func storyboard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    //MARK:- navigateToDashboard
    func navigateToDashboard()
    {
        customTabbarVc = self.storyboard().instantiateViewController(withIdentifier: "CustomTabBarController") as? CustomTabBarController
        
        if let rootNavigatioVC : UINavigationController = self.window?.rootViewController as? UINavigationController
        {
            rootNavigatioVC.pushViewController(customTabbarVc, animated: false)
        }
        
    }
    
    
    //MARK:- openConsolePipe
    func openConsolePipe() {
//    //open a new Pipe to consume the messages on STDOUT and STDERR
//        let inputPipe = Pipe()
//
//    //open another Pipe to output messages back to STDOUT
//        let outputPipe = Pipe()
            

            
    let pipeReadHandle = inputPipe.fileHandleForReading

    //from documentation
    //dup2() makes newfd (new file descriptor) be the copy of oldfd (old file descriptor), closing newfd first if necessary.
            
    //here we are copying the STDOUT file descriptor into our output pipe's file descriptor
    //this is so we can write the strings back to STDOUT, so it can show up on the xcode console
    dup2(STDOUT_FILENO, outputPipe.fileHandleForWriting.fileDescriptor)
            
    //In this case, the newFileDescriptor is the pipe's file descriptor and the old file descriptor is STDOUT_FILENO and STDERR_FILENO
                    
    dup2(inputPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
    dup2(inputPipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO)

    //listen in to the readHandle notification
    NotificationCenter.default.addObserver(self, selector: #selector(self.handlePipeNotification), name: FileHandle.readCompletionNotification, object: pipeReadHandle)

    //state that you want to be notified of any data coming across the pipe
        
        pipeReadHandle.readInBackgroundAndNotify()
        
    
    }

    @objc func handlePipeNotification(notification: Notification) {
        
    //note you have to continuously call this when you get a message
    //see this from documentation:
    //Note that this method does not cause a continuous stream of notifications to be sent. If you wish to keep getting notified, you’ll also need to call readInBackgroundAndNotify() in your observer method.
        inputPipe.fileHandleForReading.readInBackgroundAndNotify()

        if let data = notification.userInfo![NSFileHandleNotificationDataItem] as? Data,
       let str = String(data: data, encoding: String.Encoding.ascii) {
        
    //write the data back into the output pipe. the output pipe's write file descriptor points to STDOUT. this allows the logs to show up on the xcode console
        outputPipe.fileHandleForWriting.write(data)
//            if str != "" && str.count > 30{
//                Logger.sendLogMessage(log: str)
//            }

    // `str` here is the log/contents of the print statement
    //if you would like to route your print statements to the UI: make
    //sure to subscribe to this notification in your VC and update the UITextView.
    //Or if you wanted to send your print statements to the server, then
    //you could do this in your notification handler in the app delegate.
       }
    }

}

