//
//  Color.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/27.
//

import Foundation

import UIKit

enum QColor{
    static let backgroundColor = QColorPallete.white
    static let fontColor = QColorPallete.black
    static let accentColor = QColorPallete.brown
    static let grayColor = QColorPallete.lightGray
    static let subDeepColor = QColorPallete.deepGreen
    static let subLightColor = QColorPallete.lightGreen
    
}

enum QColorPallete {
    static let white = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    static let black = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    static let brown = UIColor(red: 147/255, green: 85/255, blue: 59/255, alpha: 1)
    static let lightGray = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
    static let deepGreen = UIColor(red: 1/255, green: 71/255, blue: 0/255, alpha: 1)
    static let lightGreen = UIColor(red: 141/255, green: 180/255, blue: 111/255, alpha: 1)
}
