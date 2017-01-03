//
//  FacialExpression.swift
//  FaceIt
//
//  Created by 魏雄飞 on 2017/1/3.
//  Copyright © 2017年 Fruce.Wei. All rights reserved.
//

import Foundation



/// 将眼睛的类型，嘴巴的类型，眉毛的类型统一在一个文件中。方便管理。
struct FacialExpression {
    enum Eyes: Int {
        case Open
        case Closed
        case Squinting
    }
    
    enum EyeBrows: Int {
        case Relaxed
        case Normal
        case Furrowed
        
        /// 添加更改类型的方法。枚举是Int类型，所以可以直接通过rawValue值取，当超出其范围的时候，给一个默认值。
        ///
        /// - Returns: 类型。
        func moreRelaxeBrow() -> EyeBrows {
            return EyeBrows(rawValue: rawValue - 1) ?? .Relaxed
        }
        
        func moreFurriwedBrow() -> EyeBrows {
            return EyeBrows(rawValue: rawValue + 1) ?? .Furrowed
        }
    }
    
    enum Mouth: Int {
        case Frown
        case Smirk
        case Neutral
        case Grin
        case Smile
        
        func sadderMouth() -> Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .Frown
        }
        
        func happieMouth() -> Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .Smile
        }
    }
    
    var eyes: Eyes
    var eyeBrows: EyeBrows
    var mouth: Mouth
    
    /// 自定义了一个初始化方法，方便在创建的时候有提示。
    ///
    /// - Parameters:
    ///   - eyes: 眼睛类型
    ///   - eyeBrows: 眉毛类型
    ///   - mouth: 嘴巴类型
    init(eyes: Eyes, eyeBrows: EyeBrows, mouth: Mouth) {
        self.eyes = eyes
        self.eyeBrows = eyeBrows
        self.mouth = mouth
    }
}
