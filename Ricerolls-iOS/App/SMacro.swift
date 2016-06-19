//
//  SMacro.swift
//  Ricerolls-iOS
//
//  Created by 郑先生 on 16/6/16.
//  Copyright © 2016年 郑先生. All rights reserved.
//

import Foundation
import UIKit

let kDeviceWidth = UIScreen.mainScreen().bounds.size.width
let kDeviceHeight = UIScreen.mainScreen().bounds.size.height


/**
 *  version
 */

let OS_VERSION: Float = {
    return (UIDevice.currentDevice().systemVersion as NSString).floatValue
}()

let OS_DEVICE: String = {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machine = systemInfo.machine
    let mirror = Mirror(reflecting: machine)
    var identifier = ""
    
    for child in mirror.children {
        if let value = child.value as? Int8 where value != 0 {
            identifier.append(UnicodeScalar(UInt8(value)))
        }
    }
    switch identifier {
    case "iPhone1,1": return "iPhone 2G"
    case "iPhone1,2": return "iPhone 3G"
    case "iPhone2,1": return "iPhone 3GS"
    case "iPhone3,1", "iPhone3,2": return "iPhone 4"
    case "iPhone3,3": return "iPhone 4 (CDMA)"
    case "iPhone4,1": return "iPhone 4S"
    case "iPhone5,1": return "iPhone 5"
    case "iPhone5,2": return "iPhone 5 (GSM+CDMA)"
    case "iPhone5,3": return "iPhone 5c (GSM+CDMA)"
    case "iPhone5,4": return "iPhone 5c (UK+Europe+Asia+China)"
    case "iPhone6,1": return "iPhone 5s (GSM+CDMA)"
    case "iPhone6,2": return "iPhone 5s (UK+Europe+Asia+China)"
    case "iPhone7,1": return "iPhone 6 Plus"
    case "iPhone7,2": return "iPhone 6"
    case "iPhone8,2": return "iPhone 6s Plus"
    case "iPhone8,1": return "iPhone 6s"
    case "iPhone8,4": return "iPhone SE"
        
    case "iPod1,1": return "iPod Touch (1 Gen)"
    case "iPod2,1": return "iPod Touch (2 Gen)"
    case "iPod3,1": return "iPod Touch (3 Gen)"
    case "iPod4,1": return "iPod Touch (4 Gen)"
    case "iPod5,1": return "iPod Touch (5 Gen)"
        
    case "iPad1,1": return "iPad"
    case "iPad1,2": return "iPad 3G"
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
    case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini"
    case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
    case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
    case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
    case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini Retina"
    case "iPad4,7", "iPad4,8": return "iPad Mini 3"
    case "iPad5,3", "iPad5,4": return "iPad Air 2"
    case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8": return "iPad Pro"
        
    default: return "Simulator"
    }
}()

let IOS8_OR_LATER = OS_VERSION >= 8.0
let IOS9_OR_LATER = OS_VERSION >= 9.0


/**
 *  font
 */

func kFont(args : CGFloat) -> UIFont
{
    return UIFont.systemFontOfSize(args)
}

func kBoldFont(args : CGFloat) -> UIFont
{
    return UIFont.boldSystemFontOfSize(args)
}

/**
 *  color
 */

func HexRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func HexRGBAlpha(rgbValue: UInt,alpha : Float) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(alpha)
    )
}



func getRandomColor() -> UIColor{
    
    let randomRed:CGFloat = CGFloat(drand48())
    
    let randomGreen:CGFloat = CGFloat(drand48())
    
    let randomBlue:CGFloat = CGFloat(drand48())
    
    return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    
}