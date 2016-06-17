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