//
//  TitleScene.swift
//  LearnGame
//
//  Created by Mac on 8/9/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import Foundation
import SpriteKit

class TitleScene: SKScene {
    
    var btnPlay: UIButton!
    var gameTitle: UILabel!
    
    
    var textColorHUB = UIColor(red: (100/255), green: (40/255), blue: (140/255), alpha: 1.0)
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.purpleColor()
        
        setUpText()
    }
    
    func setUpText() {
        btnPlay = UIButton(frame:CGRect(x:100, y:100, width:400, height:100))
        btnPlay.center = CGPoint(x:view!.frame.size.width/2, y: 1100)
        btnPlay.titleLabel?.font = UIFont(name: "Futura", size: 150)
        btnPlay.setTitle("PLAY", forState: UIControlState.Normal)
        btnPlay.setTitleColor(textColorHUB, forState: UIControlState.Normal)
        btnPlay.addTarget(self, action: #selector(TitleScene.playTheGame), forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(btnPlay)
        
        gameTitle = UILabel(frame: CGRect(x:0, y:0, width: view!.frame.width, height:300))
        gameTitle!.textColor = textColorHUD
        gameTitle!.font = UIFont(name: "Futura", size: 80)
        gameTitle!.textAlignment = NSTextAlignment.Center
        gameTitle!.text = "GALAXY QUEST"
        
        self.view?.addSubview(gameTitle)
    }
    
    func playTheGame() {
        self.view?.presentScene(GameScene(), transition: SKTransition.crossFadeWithDuration(1.0))
        btnPlay.removeFromSuperview()
        gameTitle.removeFromSuperview()
        
        if let scene = GameScene(fileNamed: "GameScene") {
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
    }
}