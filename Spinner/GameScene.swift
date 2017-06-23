//
//  GameScene.swift
//  Spinner
//
//  Created by Evan Chen on 6/23/17.
//  Copyright © 2017 Evan Chen. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var spinner: SKSpriteNode!
    
    var centerLock: SKSpriteNode!
    
    var touchNode: SKSpriteNode!
    
    
    var startTouch = CGPoint.zero
    
    var touchJoint: SKPhysicsJointSpring?

    let userDefults = UserDefaults.standard
    
    //spins detection
    var spinNode: SKLabelNode!
    var hitSignal: SKSpriteNode!
    
    var spinTemp:UInt64 = 0{
        didSet{
            if(spinTemp%3==0){
                spins+=1
            }
        }
    }
    
    var spins:UInt64 = 0{
        didSet{
            spinNode!.text = "Spins : \(spins)"
            userDefults.set(spins, forKey: "spins")
        }
    }
    
    
    override func didMove(to view: SKView) {
      
        spinner = (self.childNode(withName: "Spinner") as! SKSpriteNode)
        centerLock = (self.childNode(withName: "CenterPin") as! SKSpriteNode)
        touchNode = (self.childNode(withName: "touchNode") as! SKSpriteNode)
        spinNode = (self.childNode(withName: "SpinNode") as! SKLabelNode)
        hitSignal = (self.childNode(withName: "hitDetector") as! SKSpriteNode)

        
        physicsWorld.contactDelegate = self
       
        if let s = userDefults.value(forKey: "spins") {
            spins = s as! UInt64
        } else {
            
        }
        
        
        addPin()
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let pointA = contact.bodyA
        let pointB = contact.bodyB
        
        if( pointA.node!.name == "Spinner" && pointB.node!.name == "hitDetector" || pointB.node!.name == "Spinner" && pointA.node!.name == "hitDetector"){
            spinTemp+=1
        }
        
    }
    
    func addPin(){
        
        let centerPin = CGPoint(x:0,y:0)
        let spinnerLock = SKPhysicsJointPin.joint(withBodyA: centerLock.physicsBody!, bodyB: spinner.physicsBody!, anchor: centerPin)
        physicsWorld.add(spinnerLock)
        
               
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //if touched before remove previous joint
        if( touchJoint != nil ){
            physicsWorld.remove(touchJoint!)
        }
        
        //set locations of touches
        let touch = touches.first!
        let recentTouch = touch.location(in: self)
        startTouch = touch.location(in: self)

        touchNode.position = recentTouch
        
        
        
        //seak if start was spinner
        
        if( atPoint(startTouch).name == "Spinner" ){
            
            //continue with code
            touchJoint = SKPhysicsJointSpring.joint(withBodyA: touchNode.physicsBody!, bodyB: spinner.physicsBody!, anchorA: recentTouch, anchorB: startTouch)
            physicsWorld.add(touchJoint!)
            touchJoint!.frequency = 6
            touchJoint!.damping = 0.5
            
        }
        

        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let recentTouch = touch.location(in: self)
        touchNode.position = recentTouch
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchNode.position = centerLock.position
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
