//
//  GameScene.swift
//  LearnGame
//
//  Created by Mac on 8/9/16.
//  Copyright (c) 2016 STDESIGN. All rights reserved.
//

import SpriteKit

var endScene = EndScene()

// PLAYER: VARIABLES
var player = SKSpriteNode?()
var isAlive = true

// PROJECTILE: VARIABLES
var projectile = SKSpriteNode?()
var fireProjectileRate = 0.2
var projectileSpeed = 0.9

// OTHER WEAPONS: VARIABLES
var twinBlasterLeft = SKSpriteNode?()
var twinBlasterRight = SKSpriteNode?()

var firetwinBlasterRate = 0.2
var twinBlasterSpeed = 0.9

// ENEMY: VARIABLES
var enemy = SKSpriteNode?()
var enemySpeed = 2.1
var enemySpawnRate = 0.6


// GAMESCREEN: VARIABLES
var scoreLabel = SKLabelNode?()
//var scoreLabel = UILabel
var mainLabel = SKLabelNode?()
var score  = 0
var textColorHUD = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)


struct physicsCategory{
    static let player: UInt32 = 1           //00000000000000000000000000000001
    static let enemy: UInt32 = 2            //00000000000000000000000000000010
    static let projectile: UInt32 = 3       //00000000000000000000000000000100
    static let projectileLeft: UInt32 = 4
    static let projectileRight: UInt32 = 5
    
}


class GameScene: SKScene, SKPhysicsContactDelegate {

    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        
        self.scene?.backgroundColor = UIColor.blackColor()
        //self.scene?.size = CGSize(width:self.frame.width, height:self.frame.height)
        self.addChild(SKEmitterNode(fileNamed: "MagicParticle")!)
        
        //self.backgroundColor = UIColor(red: (100/255), green: (40/255), blue: (140/255), alpha: 1.0)
        spawnPlayer()
        spawnScoreLabel()
        spawnMainLabel()
        spawnTwinBlaster()
        //spawnProjectile()
        spawnEnemy()
        fireTwinBlaster()
        //fireProjectile()
        randomEnemyTimerSpawn()
        updateScore()
        hideLabel()
        resetVariablesOnStart()
    }
    // END OF FUNC: didMoveToView

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
            
            if isAlive == true {
                player?.position.x = touchLocation.x
            }
            
            if isAlive == false {
                player?.position.x = -200
                // Moving it off the screen
            }

        }
    }
    // END OF FUNC: touchesBegan
    
   
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.locationInNode(self)

            if isAlive == true {
                player?.position.x = touchLocation.x
                player?.position.y = touchLocation.y
                // Moving it anywhere on the screen
            }

            if isAlive == false {
                player?.position.x = -200
                // Moving it off the screen
            }
        }
    }
    // END OF FUNC: touchedMoved
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if isAlive == false {
            player?.position.x = -200
            // Moving it off the screen
        }
    }
    // END OF FUNC: update
    
    
    func spawnScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed:"Futura")
        scoreLabel?.text = "SCORE: 0"
        scoreLabel?.horizontalAlignmentMode = .Right
        scoreLabel?.verticalAlignmentMode = .Top
        scoreLabel?.position = CGPoint(x:200, y:CGRectGetMaxY(self.frame))
        scoreLabel?.fontSize = 50
        scoreLabel?.fontColor = textColorHUD
        self.addChild(scoreLabel!)
    }
    // END OF FUNC: spawnScoreLabel
    
    
    func spawnMainLabel() {
        mainLabel = SKLabelNode(fontNamed:"Futura")
        mainLabel?.fontSize = 100
        mainLabel?.fontColor = textColorHUD
        mainLabel?.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        mainLabel?.text = "Start"
        
        self.addChild(mainLabel!)
    }
    // END OF FUNC: spawnMainlabel()

    
    
    func spawnPlayer() {
        player = SKSpriteNode(imageNamed:"Spaceship1")
        player?.position = CGPointMake(self.size.width/2, self.size.height/5)
        //player = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width:40, height:40))
        //player?.position = CGPoint(x:CGRectGetMidX(self.frame), y: 200)

        player?.physicsBody = SKPhysicsBody(rectangleOfSize: (player?.size)!)
        player?.physicsBody?.affectedByGravity = false
        player?.physicsBody?.categoryBitMask = physicsCategory.player
        player?.physicsBody?.contactTestBitMask = physicsCategory.enemy
        player?.physicsBody?.dynamic = false
        
        self.addChild(player!)
    }
    // END OF FUNC: spawnPlayer
    

    func spawnProjectile() {
        //projectile = SKSpriteNode(color:UIColor.whiteColor(), size: CGSize(width: 10, height: 10))
        projectile = SKSpriteNode(imageNamed: "Weapon1")
        projectile!.position = CGPoint(x: (player?.position.x)!, y:(player?.position.y)!)

        projectile?.physicsBody = SKPhysicsBody(rectangleOfSize: (projectile?.size)!)
        projectile?.physicsBody?.affectedByGravity = false
        projectile?.physicsBody?.categoryBitMask = physicsCategory.projectile
        projectile?.physicsBody?.contactTestBitMask = physicsCategory.enemy
        projectile?.physicsBody?.dynamic = false
        
        //Place the projectile on the bottom
        projectile?.zPosition = -5
        
        let moveForward = SKAction.moveToY(self.size.height,duration: projectileSpeed)
        let destroy = SKAction.removeFromParent()
        
        projectile!.runAction(SKAction.sequence([moveForward, destroy]))
        
        self.addChild(projectile!)
    }
    // END OF FUNC: spawnProjectile
    
    
    func spawnTwinBlaster() {
        twinBlasterLeft = SKSpriteNode(imageNamed: "Weapon2")
        //twinBlasterLeft = SKSpriteNode(color:UIColor.blueColor(), size: CGSize(width: 10, height: 20))
        twinBlasterLeft!.position = CGPoint(x: (player?.position.x)!-15, y:((player?.position.y)!))
        
        twinBlasterLeft?.physicsBody = SKPhysicsBody(rectangleOfSize: (twinBlasterLeft?.size)!)
        twinBlasterLeft?.physicsBody?.affectedByGravity = false
        twinBlasterLeft?.physicsBody?.categoryBitMask = physicsCategory.projectileLeft
        twinBlasterLeft?.physicsBody?.contactTestBitMask = physicsCategory.enemy
        twinBlasterLeft?.physicsBody?.dynamic = false
        
        twinBlasterRight = SKSpriteNode(imageNamed: "Weapon2")
        //twinBlasterRight = SKSpriteNode(color:UIColor.greenColor(), size: CGSize(width: 10, height: 20))
        twinBlasterRight!.position = CGPoint(x: (player?.position.x)!+15, y:((player?.position.y)!))
        
        twinBlasterRight?.physicsBody = SKPhysicsBody(rectangleOfSize: (twinBlasterRight?.size)!)
        twinBlasterRight?.physicsBody?.affectedByGravity = false
        twinBlasterRight?.physicsBody?.categoryBitMask = physicsCategory.projectileRight
        twinBlasterRight?.physicsBody?.contactTestBitMask = physicsCategory.enemy
        twinBlasterRight?.physicsBody?.dynamic = false
        
        //Place the blaster on the bottom
        twinBlasterLeft?.zPosition = -1
        twinBlasterRight?.zPosition = -1
        
        let moveForward = SKAction.moveToY(self.size.height,duration: twinBlasterSpeed)
        let destroy = SKAction.removeFromParent()
        
        twinBlasterLeft!.runAction(SKAction.sequence([moveForward, destroy]))
        twinBlasterRight!.runAction(SKAction.sequence([moveForward, destroy]))
        
        self.addChild(twinBlasterLeft!)
        self.addChild(twinBlasterRight!)

    }
    // END OF FUNC: spawnProjectile

    
    func fireTwinBlaster() {
        let fireTwinBlasterTimer = SKAction.waitForDuration(firetwinBlasterRate)
        
        let spawn = SKAction.runBlock{
            self.spawnTwinBlaster()
        }
        
        let sequence = SKAction.sequence([fireTwinBlasterTimer, spawn])
        
        self.runAction(SKAction.repeatActionForever(sequence))
    }
    // END OF FUNC: fireProjectile

    
    func spawnEnemy() {
        enemy = SKSpriteNode(imageNamed: "Enemy1")
        var minValue = self.size.width/8
        var maxValue = self.size.width-20
        var spawnPoint = UInt32(maxValue - minValue)
        
        //enemy = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width:30, height:30))
        enemy!.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)), y: self.size.height)
        
        enemy?.physicsBody = SKPhysicsBody(rectangleOfSize: enemy!.size)
        enemy?.physicsBody?.affectedByGravity = false
        enemy?.physicsBody?.categoryBitMask = physicsCategory.enemy
        enemy?.physicsBody?.contactTestBitMask = physicsCategory.projectile
        enemy?.physicsBody?.allowsRotation = false
        enemy?.physicsBody?.dynamic = true
        
        var moveForward = SKAction.moveToY(-100, duration: enemySpeed)
        let destroy = SKAction.removeFromParent()
        
        enemy?.runAction(SKAction.sequence([moveForward, destroy]))
        
        if isAlive == false {
            moveForward = SKAction.moveToY(2000, duration: 1.0)
        }
        self.addChild(enemy!)
    }
    // END OF FUNC: spawnEnemy
    
    
    func spawnExplosion(enemyTemp: SKSpriteNode) {
        let explosionEmiiterPath: NSString = NSBundle.mainBundle().pathForResource("explosion", ofType: "sks")!
        
        let explosion = NSKeyedUnarchiver.unarchiveObjectWithFile(explosionEmiiterPath as String) as! SKEmitterNode
        explosion.position = CGPoint(x: enemyTemp.position.x, y: enemyTemp.position.y)
        explosion.zPosition = 1
        explosion.targetNode = self
        
        self.addChild(explosion)
        
        let explosionTimerRemove = SKAction.waitForDuration(1.0)
        
        let removeExplosion = SKAction.runBlock{
                explosion.removeFromParent()
        }
        
        self.runAction(SKAction.sequence([explosionTimerRemove, removeExplosion]))
    }
    // END OF FUNC: spawnExplosion
    
    
    
    
    func randomEnemyTimerSpawn() {
        let spawnEnemyTimer = SKAction.waitForDuration(enemySpawnRate)
        
        let spawn = SKAction.runBlock{
            self.spawnEnemy()
        }
        
        let sequence = SKAction.sequence([spawnEnemyTimer, spawn])
        
        self.runAction(SKAction.repeatActionForever(sequence))
    }
    // END OF FUNC: randomEnemyTimerSpawn
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody : SKPhysicsBody = contact.bodyA
        let secondBody : SKPhysicsBody = contact.bodyB
        
        firstBody.node!.name="firstBody"
        secondBody.node!.name="secondBody"
        
        //enemy - projectile Collision
        //if ((firstBody.categoryBitMask == physicsCategory.projectile) && (secondBody.categoryBitMask == physicsCategory.enemy)||(firstBody.categoryBitMask == physicsCategory.enemy) && (secondBody.categoryBitMask == physicsCategory.projectile)) {
            
        //    spawnExplosion(firstBody.node as! SKSpriteNode)

        //    projectileCollision(firstBody.node as! SKSpriteNode, projectileTemp: secondBody.node as! SKSpriteNode)
        //}
        
        //enemy - projectile Left Collision
        if (
            (firstBody.categoryBitMask == physicsCategory.projectileLeft) && (secondBody.categoryBitMask == physicsCategory.enemy) ||
            (firstBody.categoryBitMask == physicsCategory.enemy) && (secondBody.categoryBitMask == physicsCategory.projectileLeft) ||
            (firstBody.categoryBitMask == physicsCategory.projectileRight) && (secondBody.categoryBitMask == physicsCategory.enemy) ||
            (firstBody.categoryBitMask == physicsCategory.enemy) && (secondBody.categoryBitMask == physicsCategory.projectileRight)
            )
        {
            
            if (
                (firstBody.categoryBitMask & physicsCategory.projectileLeft != 0) &&
                (secondBody.categoryBitMask & physicsCategory.enemy != 0) ||
                (firstBody.categoryBitMask & physicsCategory.projectileRight != 0) &&
                (secondBody.categoryBitMask & physicsCategory.enemy != 0) ||
                (firstBody.categoryBitMask & physicsCategory.enemy != 0) &&
                (secondBody.categoryBitMask & physicsCategory.projectileLeft != 0) ||
                (firstBody.categoryBitMask & physicsCategory.enemy != 0) &&
                (secondBody.categoryBitMask & physicsCategory.projectileRight != 0))
            {
            
            spawnExplosion(firstBody.node as! SKSpriteNode)
            projectileCollision(firstBody.node as! SKSpriteNode, projectileTemp: secondBody.node as! SKSpriteNode)
            }
        }
        
        //player - enemy Collision
        if ((firstBody.categoryBitMask == physicsCategory.enemy) && (secondBody.categoryBitMask == physicsCategory.player)||(firstBody.categoryBitMask == physicsCategory.player) && (secondBody.categoryBitMask == physicsCategory.enemy)) {
            
            enemyPlayerCollision(firstBody.node as! SKSpriteNode, playerTemp: secondBody.node as! SKSpriteNode)
        }
    }
    // END OF FUNC: didBeginContact
    
    
    func projectileCollision(enemyTemp: SKSpriteNode, projectileTemp: SKSpriteNode) {
        print("enemy", enemyTemp)
        print("projectile",projectileTemp)
        
        enemyTemp.removeFromParent()
        projectileTemp.removeFromParent()
        
        score = score + 1
        
        updateScore()
    }
    // END OF FUNC: projectieCollision
    

    func enemyPlayerCollision(enemyTemp: SKSpriteNode, playerTemp: SKSpriteNode) {
        mainLabel?.fontSize = 50
        mainLabel?.alpha = 1.0
        mainLabel?.text = "Game Over"
        
        player?.removeFromParent()
        
        isAlive = false
        self.view?.presentScene(endScene)
        //waitThenMoveToTitleScreen()
    }
    // END OF FUNC: enemyPlayerCollision
    
    
    func waitThenMoveToTitleScreen() {
        let wait = SKAction.waitForDuration(0.3)
        let transition = SKAction.runBlock{
            self.view?.presentScene(TitleScene(), transition: SKTransition.crossFadeWithDuration(0.3))
        }
        
        let sequence = SKAction.sequence([wait, transition])
        
        self.runAction(SKAction.repeatAction(sequence, count: 1))
    }
    // END OF FUNC: waitThenMoveToTileScreen
    
    
    func updateScore() {
        scoreLabel!.text = "Score: \(score)"
    }
    // END OF FUNC: updateScore
    
    
    func hideLabel() {
        let wait = SKAction.waitForDuration(3.0)
        let hide = SKAction.runBlock{
            mainLabel?.alpha = 0.0
        }
        
        let sequence = SKAction.sequence([wait, hide])
        self.runAction(SKAction.repeatAction(sequence, count:1 ))
    }
    // END OF UNC: hideLabel
    
    
    func resetVariablesOnStart() {
        isAlive = true
        score = 0
    }
    // END OF FUNC: resetVariablesOnStart

}
//END OF CLASS: GameScene
