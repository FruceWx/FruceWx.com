//
//  ViewController.swift
//  FaceIt
//
//  Created by 魏雄飞 on 2017/1/3.
//  Copyright © 2017年 Fruce.Wei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    /// 创建结构体实例
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smile) {
        didSet {
            updateUI()
        }
    }
    
    
    /// 连线 faceView的实例。界面一出来就显示想要的结果。
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView, action: #selector(FaceView.changeScale(recognizer:))
            ))
            
            let happierUpSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.increaseHappiness)
            )
            
            happierUpSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierUpSwipeGestureRecognizer)
            
            let happierDownSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.increaseHappiness)
            )
            happierDownSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(happierDownSwipeGestureRecognizer)
            
            let saderLeftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.decreaseHappines)
            )
            saderLeftSwipeGestureRecognizer.direction = .left
            faceView.addGestureRecognizer(saderLeftSwipeGestureRecognizer)
            
            let saderRightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.decreaseHappines)
            )
            faceView.addGestureRecognizer(saderRightSwipeGestureRecognizer)
            
            let toggleEyes = UITapGestureRecognizer(target: self, action: #selector(ViewController.toggleEyes)
            )
            toggleEyes.numberOfTapsRequired = 1
            toggleEyes.numberOfTouchesRequired = 1
            faceView.addGestureRecognizer(toggleEyes)
            
            
            
            updateUI()
        }
    }
    
    func increaseHappiness() {
        expression.mouth = expression.mouth.happieMouth()
    }
    
    func decreaseHappines() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    func toggleEyes(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
        }
    }
    
    
    
    /// 由于FaceView中的API接口的类型是Double类型，而FacialExpression中定义的是枚举类型，所以在定义一个数组字典，可以根据枚举类型返回需要的值。
    private let mouthCurvatures = [FacialExpression.Mouth.Frown: -1.0, .Grin: 0.5, .Neutral: 0.0, .Smirk: -0.5, .Smile: 1.0]
    private let eyeBrowTilts = [FacialExpression.EyeBrows.Furrowed: 0.5, .Normal: 0.0, .Relaxed: 0.5]
    
    
    
    /// 更新界面的方法
    private func updateUI() {
        
        switch expression.eyes {
        case .Open: faceView.eyeOpen = true
        case .Closed: faceView.eyeOpen = false
        case .Squinting: faceView.eyeOpen = false
        }
        
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

