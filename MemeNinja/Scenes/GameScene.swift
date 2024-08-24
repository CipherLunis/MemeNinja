//
//  GameScene.swift
//  MemeNinja
//
//  Created by Cipher Lunis on 8/23/24.
//

import Foundation
import SpriteKit

class GameScene: SKScene, ObservableObject {
    
    var pointsLabel = SKLabelNode(fontNamed: "ArialRoundedMT")
    
    @Published var isGameOver = false
    @Published var points = 0
    
    private var memeTimer = Timer()
    private var bombTimer = Timer()
    
    private var hearts: [SKSpriteNode] = []
    
    private var lives = 3
    
    private let memeImageNames = ["Crewmate", "PickleRick", "GrimaceShake", "Ohio", "SkibidiToilet"]
    
    private let soundQueue = DispatchQueue(label: "com.cipherlunis.memeninja.soundqueue")
    
    override init(size: CGSize) {
        super.init(size: size)
        self.size = size
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        scene?.scaleMode = .fill
        anchorPoint = .zero
        
        createBackground()
        createPointsLabel()
        createHearts()
        
        memeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(spawnMeme), userInfo: nil, repeats: true)
        bombTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(spawnBomb), userInfo: nil, repeats: true)
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
    }
    
    private func createBackground() {
        let background = SKSpriteNode(texture: SKTexture(imageNamed: "WoodBG"))
        background.anchorPoint = .zero
        background.size = frame.size
        addChild(background)
    }
    
    private func createPointsLabel() {
        pointsLabel.text = "\(points)"
        pointsLabel.position = CGPoint(x: frame.width/2, y: frame.height/100*75.5)
        pointsLabel.fontSize = 80
        pointsLabel.fontColor = .white
        pointsLabel.zPosition = 5
        addChild(pointsLabel)
    }
    
    private func createHearts() {
        for i in 0..<3 {
            let heartSize = CGSize(width: frame.width/16, height: frame.width/16)
            let heartXInitialPos = frame.width/18
            let heartWidthOffset = CGFloat(i)*frame.width/16.0
            let additionalOffset = frame.width/18
            let heartX: CGFloat = heartXInitialPos + heartWidthOffset + additionalOffset
            let heart = createHeart(x: heartX, size: heartSize)
            addChild(heart)
            
            hearts.append(heart)
        }
    }
    
    private func createHeart(x: CGFloat, size: CGSize) -> SKSpriteNode {
        let heart = SKSpriteNode(texture: SKTexture(imageNamed: "Heart"))
        heart.size = size
        heart.position = CGPoint(x: x, y: frame.height/8*7)
        heart.zPosition = 3
        return heart
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: view)
            for node in nodes(at: touchLocation) {
                if node.name != nil {
                    guard let node = node as? SKSpriteNode else { return }
                    if node.name!.contains("Meme") {
                        // cut node in half
                        cutMemeInHalf(meme: node)
                        points += 1
                        pointsLabel.text = "\(points)"
                        soundQueue.async {
                            SoundManager.sharedInstance.playSound(fileName: "Slice")
                        }
                    } else if node.name! == "Bomb" {
                        lives -= 1
                        let removedHeart = hearts.popLast()
                        removedHeart?.removeFromParent()
                        cutBombInHalf(bomb: node)
                        if lives == 0 {
                            gameOver()
                        }
                    }
                }
                
            }
        }
    }
    
    private func gameOver() {
        isGameOver = true
        
        enumerateChildNodes(withName: "//*", using:
        { (node, stop) -> Void in
            if node.physicsBody != nil {
                node.physicsBody = nil
            }
        })
        memeTimer.invalidate()
        bombTimer.invalidate()
    }
    
    private func cutMemeInHalf(meme: SKSpriteNode) {
        guard let memeVelocity = meme.physicsBody?.velocity else { return }
        meme.removeFromParent()
        var memeImageName = meme.name!
        if let range = memeImageName.range(of: "Meme") {
            let startIndex = range.upperBound
            memeImageName = String(memeImageName[startIndex...])
        }
        meme.name = memeImageName
        spawnObjectHalves(object: meme, objectVelocity: memeVelocity)
    }
    
    private func cutBombInHalf(bomb: SKSpriteNode) {
        guard let bombVelocity = bomb.physicsBody?.velocity else { return }
        bomb.removeFromParent()
        spawnObjectHalves(object: bomb, objectVelocity: bombVelocity)
    }
    
    private func spawnObjectHalves(object: SKSpriteNode, objectVelocity: CGVector) {
        let objectSize = CGSize(width: frame.width/10, height: frame.width/10)
        let objectHalf1 = SKSpriteNode(texture: SKTexture(imageNamed: object.name! + "1"))
        let objectHalf2 = SKSpriteNode(texture: SKTexture(imageNamed: object.name! + "2"))
        objectHalf1.physicsBody = SKPhysicsBody(rectangleOf: objectSize)
        objectHalf1.physicsBody?.velocity = CGVector(dx: -125.0, dy: objectVelocity.dy)
        objectHalf1.physicsBody?.collisionBitMask = 0
        objectHalf1.physicsBody?.affectedByGravity = true
        objectHalf1.size = objectSize
        objectHalf1.name = object.name! + "1"
        objectHalf1.position = CGPoint(x: object.position.x - frame.width/20, y: object.position.y)
        
        objectHalf2.physicsBody = SKPhysicsBody(rectangleOf: objectSize)
        objectHalf2.physicsBody?.velocity = CGVector(dx: 125.0, dy: objectVelocity.dy)
        objectHalf2.physicsBody?.collisionBitMask = 0
        objectHalf2.physicsBody?.affectedByGravity = true
        objectHalf2.size = objectSize
        objectHalf2.name = object.name! + "2"
        objectHalf2.position = CGPoint(x: object.position.x + frame.width/20, y: object.position.y)
        addChild(objectHalf1)
        addChild(objectHalf2)
    }
    
    @objc private func spawnMeme() {
        guard let memeImageName = memeImageNames.randomElement() else { return }
        spawnObject(prefix: "Meme", objectName: memeImageName)
    }

    @objc private func spawnBomb() {
        spawnObject(prefix: "", objectName: "Bomb")
    }
    
    private func spawnObject(prefix: String, objectName: String) {
        let object = SKSpriteNode(texture: SKTexture(imageNamed: objectName))
        let objectSize = CGSize(width: frame.width/6, height: frame.width/6)
        object.physicsBody = SKPhysicsBody(rectangleOf: objectSize)
        object.physicsBody?.velocity = CGVector(dx: CGFloat.random(in: -125.0...125.0), dy: CGFloat.random(in: 350.0...400.0))
        object.physicsBody?.collisionBitMask = 0
        object.physicsBody?.affectedByGravity = true
        object.size = objectSize
        object.name = prefix + objectName
        object.position = CGPoint(x: CGFloat.random(in: 0.0...frame.width), y: 0.0)
        addChild(object)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // clean up nodes that went off screen
        enumerateChildNodes(withName: "//*", using:
        { (node, stop) -> Void in
            if node.position.y < -self.frame.height/12 {
                node.removeFromParent()
            }
        })
    }
}
