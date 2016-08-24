//
//  EndScene.swift
//  LearnGame
//
//  Created by Mac on 8/23/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import Foundation
import SpriteKit

class EndScene : SKScene {
    
    var restartBtn: UIButton!
    var titleScene = TitleScene()
    
    override func didMoveToView(view: SKView) {
        
        scene?.backgroundColor = UIColor.whiteColor()
        
        restartBtn = UIButton(frame: CGRect(x:0, y:0, width: view.frame.size.width/3, height:30))
        restartBtn.center = CGPoint(x:view.frame.size.width/2, y: view.frame.size.width/7)
        restartBtn.setTitle("Restart", forState: UIControlState.Normal)
        restartBtn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        restartBtn.addTarget(self, action: #selector(EndScene.Restart), forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(restartBtn)
    }
    
    func Restart(){
        self.view?.presentScene(titleScene, transition: SKTransition.crossFadeWithDuration(0.3))
    }
}
