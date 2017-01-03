//
//  FaceView.swift
//  FaceIt
//
//  Created by 魏雄飞 on 2017/1/3.
//  Copyright © 2017年 Fruce.Wei. All rights reserved.
//

import UIKit

@IBDesignable           //直接显示在Storyboard中
class FaceView: UIView {
    @IBInspectable      //在故事版中的属性栏中 显示 并且可以编辑
    /// 控制视图的大小
    //因为Swift中的计算，必须是同一类型。所以创建的时候就定义了CGFloat类型。
    //调用didSet 方法，在故事版中 更改了属性的值，故事版就会显示出来
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
    @IBInspectable
    /// 控制视图线条的粗细
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    /// 线条的颜色
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    @IBInspectable
    /// 嘴的笑或哭
    var mouthCurvature: Double = 1 { didSet { setNeedsDisplay() } }//1 full smile, -1 full frown
    @IBInspectable
    /// 眼睛是否睁开
    var eyeOpen: Bool = false { didSet { setNeedsDisplay() } }
    @IBInspectable
    /// 眉毛的样式
    var eyeBrowTilt: Double = 0.5 { didSet { setNeedsDisplay() } }//由于是 -1～1 之间，所以定义Double类型。
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            scale *= recognizer.scale
            recognizer.scale = 1
        default:
            break
        }
    }
    
    /// 计算型属性，根据屏幕的大小得到的值。根据其值，得到其它需要的数值。
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    /// 同上
    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    
    /// 封装一个画圆的方法。
    ///
    /// - Parameters:
    ///   - midCenter: 圆的中心点
    ///   - radius: 圆的半径
    /// - Returns: 画笔
    private func pathForCircleCenterAndRadius(midCenter: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: midCenter, radius: radius, startAngle: 0.0, endAngle: CGFloat(2 * M_PI), clockwise: false)
        path.lineWidth = lineWidth
        return path
    }
    
    
    /// 左右眼。执行同样的逻辑，但不同类型，用枚举。
    ///
    /// - Left: 左眼
    /// - Right: 右眼
    enum Eye {
        case Left
        case Right
    }
    
    /// 存储需要值的参数。static 静态全局，修饰后，才能在类中其它方法使用其变量／常量
    private struct Rations {
        //因为Swift中的计算，必须是同一类型。所以创建的时候就定义了CGFloat类型。
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
        static let SkullRadiusToEyeBrowOffset: CGFloat = 5
    }
    
    
    /// 封装取得眼睛的中心点方法
    ///
    /// - Parameter eye: 枚举判定左右眼
    /// - Returns: 中心点。根据枚举的类型返回中心点
    private func getEyeCenter(eye: Eye) -> CGPoint {
        let eyeOffset = skullRadius / Rations.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    /// 画眼睛
    ///
    /// - Parameter eye: 眼睛类型（左眼， 右眼）
    /// - Returns: 画笔
    private func pathForEyes(eye: Eye) -> UIBezierPath {
        let eyeRadius = skullRadius / Rations.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye: eye)
        
        if eyeOpen {
            let path = pathForCircleCenterAndRadius(midCenter: eyeCenter, withRadius: eyeRadius)
            path.lineWidth = lineWidth
            return path
        } else {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            path.lineWidth = lineWidth
            return path
            
        }
        
        
    }
    
    /// 画眉毛
    ///
    /// - Parameter eye: 眼睛的类型
    /// - Returns: 画笔
    private func pathForEyeBrows(eye: Eye) -> UIBezierPath {
        var tilt = eyeBrowTilt
        switch eye {
        case .Left: tilt *= -1
        case .Right: break
        }
        
        var browCenter = getEyeCenter(eye: eye)
        browCenter.y -= skullRadius / Rations.SkullRadiusToEyeBrowOffset
        let eyeRadius = skullRadius / Rations.SkullRadiusToEyeRadius
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
    /// 画嘴巴
    ///
    /// - Returns: 嘴巴的画笔
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Rations.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Rations.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Rations.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth / 2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cpOne = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cpTwo = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cpOne, controlPoint2: cpTwo)
        path.lineWidth = lineWidth
        return path
    }

    
    /// 显示方法。
    ///
    /// - Parameter rect: 本身View的frame大小
    override func draw(_ rect: CGRect) {
        color.set()
        pathForCircleCenterAndRadius(midCenter: skullCenter, withRadius: skullRadius).stroke()
        pathForEyes(eye: .Left).stroke()
        pathForEyes(eye: .Right).stroke()
        pathForMouth().stroke()
        pathForMouth().stroke()
        pathForEyeBrows(eye: .Left).stroke()
        pathForEyeBrows(eye: .Right).stroke()
    }
    
}









