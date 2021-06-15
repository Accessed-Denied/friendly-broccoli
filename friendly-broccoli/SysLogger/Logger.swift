//
//  Logger.swift
//  EASY
//
//  Created by Rohit Saini on 23/12/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import Foundation
import FirebaseFirestore


//******************************************************************************************
//***********************  LOGGER  *********************************************************
//MARK: - LOGGER SETUP START
enum LogDateFormatter: String {
    case MM_dd_yyyy_HH_mm_ss_SSS = "MM/dd/yyyy HH:mm:ss:SSS"
    case MM_dd_yyyy_HH_mm_ss = "MM-dd-yyyy HH:mm:ss"
    case E_d_MMM_yyyy_HH_mm_ss_Z = "E, d MMM yyyy HH:mm:ss Z"
    case MMM_d_HH_mm_ss_SSSZ = "MMM d, HH:mm:ss:SSSZ"
}

struct LogOptions {
    static var dateFormatter = LogDateFormatter.MMM_d_HH_mm_ss_SSSZ
}

struct Log {
    static func stats(_ file: String = #file, function: String = #function, line: Int = #line) -> String {
        let fileString: NSString = NSString(string: file)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = LogOptions.dateFormatter.rawValue
        if Thread.isMainThread {
            return "[M] [\(dateFormatter.string(from: Foundation.Date()))] [\(fileString.lastPathComponent) -> \(function), line:\(line)] ~~>"
        } else {
            return "[!=M] [\(dateFormatter.string(from: Foundation.Date()))] [\(fileString.lastPathComponent) -> \(function), line:\(line)] ~~>"
        }
    }
}

enum log {
    case ln(_: String)
    case success(_: String)
    case warning(_: String)
    case error(_: String)
    case todo(_: String)
    case url(_: String)
}

postfix operator /

postfix func / (target: log?) {
    guard let target = target else { return }
    
    func log<T>(_ emoji: String, _ object: T) {
        // To enable logs only in Debug mode:
        // 1. Go to Buld Settings -> Other C Flags
        // 2. Enter `-D DEBUG` fot the Debug flag
        // 3. Comment out the `#if #endif` lines
        // 4. Celebrate. Your logs will not print in Release, thus saving on memory
        //#if DEBUG
        print(emoji + " " + String(describing: object))
        //#endif
    }
    
    switch target {
    case .ln(let line):
        log("✏️", line)
    case .success(let success):
        log("✅", success)
    case .warning(let warning):
        log("⚠️", warning)
    case .error(let error):
        log("🛑", error)
    case .todo(let todo):
        log("👨🏼‍💻", todo)
    case .url(let url):
        log("🌏", url)
    }
}
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
//&&&&&&&&&&&&&&&&&&&&&&&  FINISH LOGGER SETUP &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&



//MARK:- LOGGER UPSTREAM METHODS
class Logger: NSObject {
    
    //MARK:- sendLogMessage
    class func sendLogMessage(log:String){
        // [START setup]
        let settings = FirestoreSettings()
//        settings.areTimestampsInSnapshotsEnabled = true
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("LOGS").document()
        let logInfo:[String: Any] = ["log":log,"timestamp":Date().timeIntervalSince1970]
        ref?.setData(logInfo)
        { error in
            if let err = error {
                print("Error creating log document:\(err)")
            } else {
                print(ref!.documentID)
            }
        }
    }
    
    
    class func getMemory() {

        var taskInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        if kerr == KERN_SUCCESS {
            let usedMegabytes = taskInfo.resident_size/(1024*1024)
            print("used megabytes: \(usedMegabytes)")
        } else {
            print("Error with task_info(): " +
                (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
        }

    }

}
