//
//  UIFont+Extension.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/27.
//

import UIKit

enum PretendardFontType: String {
    case black
    case bold
    case extraBold
    case extraLightBold
    case light
    case medium
    case regular
    case semibold
    case thin
    
    var fontName: String {
        switch self {
        case .black: return "Pretendard-Black"
        case .bold: return "Pretendard-Bold"
        case .extraBold: return "Pretendard-ExtraBold"
        case .extraLightBold: return "Pretendard-ExtraLight"
        case .light: return "Pretendard-Light"
        case .medium: return "Pretendard-Medium"
        case .regular: return "Pretendard-Regular"
        case .semibold: return "Pretendard-SemiBold"
        case .thin: return "Pretendard-Thin"
        }
    }
}

enum Pretendard {
    case size9
    case size10
    case size11
    case size12
    case size13
    case size14
    case size15
    case size16
    case size17
    case size18
    case size19
    case size20
    case size21
    case size22
    case size23
    case size24
    case size25
    case size26
    case size35
    
    var size: CGFloat {
        switch self {
        case .size9: return 9
        case .size10: return 10
        case .size11: return 11
        case .size12: return 12
        case .size13: return 13
        case .size14: return 14
        case .size15: return 15
        case .size16: return 16
        case .size17: return 17
        case .size18: return 18
        case .size19: return 19
        case .size20: return 20
        case .size21: return 21
        case .size22: return 22
        case .size23: return 23
        case .size24: return 24
        case .size25: return 25
        case .size26: return 26
        case .size35: return 35
        }
    }
    
    func bold() -> UIFont {
        return UIFont(name: PretendardFontType.bold.fontName, size: self.size)!
    }
    
    func black() -> UIFont {
        return UIFont(name: PretendardFontType.black.fontName, size: self.size)!
    }
    
    func extraBold() -> UIFont {
        return UIFont(name: PretendardFontType.extraBold.fontName, size: self.size)!
    }
    
    func extraLightBold() -> UIFont {
        return UIFont(name: PretendardFontType.extraLightBold.fontName, size: self.size)!
    }
    
    func light() -> UIFont {
        return UIFont(name: PretendardFontType.light.fontName, size: self.size)!
    }
    
    func medium() -> UIFont {
        return UIFont(name: PretendardFontType.medium.fontName, size: self.size)!
    }
    
    func regular() -> UIFont {
        return UIFont(name: PretendardFontType.regular.fontName, size: self.size)!
    }
    
    func semibold() -> UIFont {
        return UIFont(name: PretendardFontType.semibold.fontName, size: self.size)!
    }
    
    func thin() -> UIFont {
        return UIFont(name: PretendardFontType.thin.fontName, size: self.size)!
    }
}


enum DinProFontType: String {
    case black
    case bold
    case medium
    case regular
    case light
    
    var fontName: String {
        switch self {
        case .black: return "DINPro-Black"
        case .bold: return "DINPro-Bold"
        case .medium: return "DINPro-Medium"
        case .regular: return "DINPro-Regular"
        case .light: return "DINPro-Light"
        }
    }
}

enum DINPro {
    case size9
    case size10
    case size11
    case size12
    case size13
    case size14
    case size15
    case size16
    case size17
    case size18
    case size19
    case size20
    case size23
    case size26
    
    var size: CGFloat {
        switch self {
        case .size9: return 9
        case .size10: return 10
        case .size11: return 11
        case .size12: return 12
        case .size13: return 13
        case .size14: return 14
        case .size15: return 15
        case .size16: return 16
        case .size17: return 17
        case .size18: return 18
        case .size19: return 19
        case .size20: return 20
        case .size23: return 23
        case .size26: return 26
        }
    }
    
    func bold() -> UIFont {
        return UIFont(name: DinProFontType.bold.fontName, size: self.size)!
    }
    
    func black() -> UIFont {
        return UIFont(name: DinProFontType.black.fontName, size: self.size)!
    }
    
    func light() -> UIFont {
        return UIFont(name: DinProFontType.light.fontName, size: self.size)!
    }
    
    func medium() -> UIFont {
        return UIFont(name: DinProFontType.medium.fontName, size: self.size)!
    }
    
    func regular() -> UIFont {
        return UIFont(name: DinProFontType.regular.fontName, size: self.size)!
    }
    
}
