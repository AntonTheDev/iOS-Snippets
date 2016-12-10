//
//  UIDevice+System.swift
//  iOS-Snippets
//
//  Created by Anton Doudarev on 12/10/16.
//  Copyright © 2016 Anton Doudarev. All rights reserved.
//

import Foundation
import UIKit

let enableiPhone4Debug = false

let isiPhone4 : Bool = isSmallDevice()

func iPhoneValue<T>(iphone4Value : T, _ iphoneValue: T) -> T {
    if isiPhone4 {
        return iphone4Value
    }
    
    return enableiPhone4Debug ? iphone4Value : iphoneValue
}

func isSmallDevice() -> Bool {
    if  UIDevice.deviceModel() == "iPhone 4"     ||
        UIDevice.deviceModel() == "iPhone 4s"    ||
        UIDevice.deviceModel() == "iPhone 5"	 ||
        UIDevice.deviceModel() == "iPhone 5c"	 ||
        UIDevice.deviceModel() == "iPhone 5s"	 ||
        UIDevice.deviceModel() == "iPhone SE"	 ||
        UIDevice.deviceModel() == "iPod Touch 2" ||
        UIDevice.deviceModel() == "iPod Touch 3" ||
        UIDevice.deviceModel() == "iPod Touch 4" ||
        UIDevice.deviceModel() == "iPhone 5/5S/5C/SE Simulator" ||
        UIDevice.deviceModel() == "iPhone 4/4S Simulator"
    {
        return true
    }
    
    return false
}

extension UIDevice {
    
    static func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod2,1":                                 return "iPod Touch 2"
        case "iPod3,1":                                 return "iPod Touch 3"
        case "iPod4,1":                                 return "iPod Touch 4"
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":								return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return simulatorDeviceIdentifier()
        default:                                        return identifier
        }
    }
    
    //MARK : - Simulator Devices
    static func simulatorDeviceIdentifier() -> String {
        let screenSize = UIScreen.main.bounds.size
        let simulatorHeight = (screenSize.height > screenSize.width) ? screenSize.height : screenSize.width
        
        switch (simulatorHeight) {
        case let x where x >= 1024.0:
            return "iPad Simulator"
        case let x where x >= 736.0:
            return "iPhone 6+/6s+ Simulator"
        case let x where x >= 667.0:
            return "iPhone 6/6s Simulator"
        case let x where x >= 568.0:
            return "iPhone 5/5S/5C/SE Simulator"
        case let x where x >= 480.0:
            return "iPhone 4/4S Simulator"
        default:
            return "Unknown Simulator"
        }
    }
}
