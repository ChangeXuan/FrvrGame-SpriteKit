//
//  GameScene.swift
//  FrvrGame
//
//  Created by 覃子轩 on 2017/5/13.
//  Copyright © 2017年 覃子轩. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    fileprivate var mapDataAry:[MapModel]!
    fileprivate var mapNodeAry:[SKSpriteNode]!
    fileprivate var mapTexture:SKTexture!
    fileprivate var mapTextureW:CGFloat!
    fileprivate var mapTextureH:CGFloat!
    fileprivate var shaperPosAry:[CGPoint]!
    fileprivate var shaderAry:NSMutableArray!
    fileprivate var handleNode:SKSpriteNode!
    
    override func sceneDidLoad() {
        self.initGameMapData()
        self.initLable()
        self.showGameMap()
        self.initPlayShape()
    }
    
}

// MARK: - UI
extension GameScene {
    
    /// 初始化label显示
    ///
    /// - returns:
    fileprivate func initLable() {
        let myLabel = SKLabelNode.init(fontNamed: "Chalkduster")
        myLabel.text = "Frvr brave go!!!"
        myLabel.fontSize = 30
        myLabel.position = CGPoint.init(x: self.frame.midX, y: self.frame.height-40)
        
        let scoreLabel = SKLabelNode.init(fontNamed: "Chalkduster")
        scoreLabel.text = "score: "
        scoreLabel.fontSize = 26
        scoreLabel.position = CGPoint.init(x: self.frame.midX-120, y: self.frame.height-90)
        
        let scoreNumberLable = SKLabelNode.init(fontNamed: "Chalkduster")
        scoreNumberLable.name = "scoreNumberLabel"
        scoreNumberLable.text = "100"
        scoreNumberLable.fontSize = 26
        scoreNumberLable.position = CGPoint.init(x: self.frame.midX, y: self.frame.height-90)
        
        self.addChild(myLabel)
        self.addChild(scoreLabel)
        self.addChild(scoreNumberLable)
    }
    
    /// 显示游戏地图
    fileprivate func showGameMap() {
        var node:SKSpriteNode
        self.mapNodeAry = []
        self.mapTexture = SKTexture.init(imageNamed: "6kuai_gray.png")
        self.mapTextureW = self.mapTexture.size().width
        self.mapTextureH = self.mapTexture.size().height
        
        let aryNumber = [5,6,7,8,9,8,7,6,5]
        let startPoint = CGPoint.init(x: self.frame.midX-2*self.mapTextureW, y: self.frame.height-150)
        
        var index = 0
        var nodeCount = 0
        for line in aryNumber {
            for i in 0..<line {
                // 每次实例一个node
                node = SKSpriteNode.init(texture: self.mapTexture)
                node.size = CGSize.init(width: self.mapTextureW, height: self.mapTextureH)
                // x的起点在中间变化
                if index <= 4 {
                    node.position = CGPoint.init(x: startPoint.x-CGFloat(23*index)+CGFloat(i)*self.mapTextureW,
                                                 y: startPoint.y-CGFloat(38*index))
                } else {
                    node.position = CGPoint.init(x: startPoint.x - CGFloat(23*(8-index)) + CGFloat(i)*self.mapTextureW,
                                                 y: startPoint.y - CGFloat(38*index))
                }
                
                let mapInfo = self.mapDataAry[nodeCount]
                mapInfo.position = node.position
                node.userData = [:]
                node.userData?.setValue(mapInfo, forKey: "mapInfo")
                node.name = "mapShape"
                
                self.addChild(node)
                // 把node装进全局数组用来后面的判断
                self.mapNodeAry.append(node)
                nodeCount += 1
            }
            index += 1
        }
    }
    
    /// 初始化游戏模块
    ///
    /// - returns:
    fileprivate func initPlayShape() {
        
        var node:SKSpriteNode
        self.shaperPosAry = []
        self.shaderAry = []
        
        for i in 0..<3 {
            node = SKSpriteNode()
            node.size = CGSize.init(width: 100, height: 100)
            node.position = CGPoint.init(x: self.frame.midX+CGFloat((i-1)*120), y: 220)
            node.name = "shapeFrame\(i)"
            self.addChild(node)
            self.shaperPosAry.append(node.position)
        }
        self.shapeFill()
    }
    
}

// MARK: - Function
extension GameScene {
    
    /// 读取本地资源文件
    ///
    /// - parameter fileName:
    ///
    /// - returns:
    fileprivate func readLocationFile(_ fileName:String) -> Data {
        let bundleDir:NSString = Bundle.main.bundlePath as NSString
        let path = bundleDir.appendingPathComponent(fileName)
        let url = URL.init(fileURLWithPath: path)
        return try! Data.init(contentsOf: url)
    }
    
    /// 初始化游戏地图数据
    ///
    /// - returns:
    fileprivate func initGameMapData() {
        
        if self.mapNodeAry != nil {
            return
        }
        self.mapDataAry = []
        let data = self.readLocationFile("unitInfo.json")
        
        let jsonDic = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        let unitInfoAry:NSArray? = jsonDic.object(forKey: "unitInfos") as? NSArray
        
        if unitInfoAry != nil {
            for item in unitInfoAry! {
                let itemDic = item as! NSDictionary
                let x:Int = itemDic.object(forKey: "x") as! Int
                let y:Int = itemDic.object(forKey: "y") as! Int
                let sn:Int = itemDic.object(forKey: "serialNum") as! Int
                let adjacentStr:NSString = itemDic.object(forKey: "adjacent") as! NSString
                let adjacentAry = adjacentStr.components(separatedBy: " ")
                
                self.mapDataAry.append(MapModel(location:CGPoint.init(x: x, y: y),
                                                position:CGPoint.init(x: x, y: y),
                                                serialNumber:sn,
                                                adjacentArry:adjacentAry,
                                                isHave:false))
            }
        }
    }
    
    /// 填满3个形状
    fileprivate func shapeFill() {
        
        let count = 3 - self.shaderAry.count
        
        for _ in 0..<count {
            let genShapeNode = RandomShapeMgr.shared().shapeGenerator()!
            self.shaderAry.add(genShapeNode)
            self.addChild(genShapeNode)
        }
        
        for i in 0..<3 {
            let shapeNode = self.shaderAry[i]
            let location = self.shaperPosAry[i]
            let move = SKAction.move(to: location, duration: 0.5)
            move.timingMode = .easeInEaseOut
            (shapeNode as AnyObject).run(move)
        }
    }
    
    /// 判断当前节点是否时地图节点
    ///
    /// - parameter node:
    ///
    /// - returns:
    fileprivate func isMapShape(_ node:SKSpriteNode) -> Bool {
        if node.name == "mapShape" {
            return true
        }
        return false
    }
    
    /// 判断当前地图节点是否已经被填上数据
    ///
    /// - parameter node:
    ///
    /// - returns:
    fileprivate func isMapInfo(_ node:SKSpriteNode) -> Bool {
        if self.isMapShape(node) {
            let mapInfo:MapModel = node.userData?.object(forKey: "mapInfo") as! MapModel
            if !mapInfo.isHave {
                return true
            }
        }
        return false
    }
    
}

// MARK: - Override
extension GameScene {
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func didMove(to view: SKView) {
//        self.initGameMapData()
//        self.initLable()
//        self.showGameMap()
//        self.initPlayShape()
    }
    
    /// 手指按下
    ///
    /// - parameter touches:
    /// - parameter event:
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        // 取得当前点击的坐标点的矩形范围内的节点集合
        let nodes = self.nodes(at: location!)
        for node in nodes {
            // 如果此节点的名字是“shape”
            if node.name == "shape" {
                self.handleNode = node as! SKSpriteNode
                self.handleNode.run(SKAction.scale(to: 2, duration: 0.2))
                break
            } else if node.name == "mapShape" {
                
            }
        }
    }
    
    /// 按下时移动
    ///
    /// - parameter touches:
    /// - parameter event:
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.handleNode != nil {
            // 移动
            self.handleNode.position = (touches.first?.location(in: self))!
            
        }
    }
    
    /// 手指抬起
    ///
    /// - parameter touches:
    /// - parameter event:
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.handleNode != nil {
            // 取得当前控制节点的所有子节点
            let handleShapeNodes = self.handleNode.children
            // 取得子节点中的一个节点的纹理
            let textureNode:SKSpriteNode = self.handleNode.children.first as! SKSpriteNode
            let texture:SKTexture = textureNode.texture!
            var index = 0
            var countd = 0
            var tempAry:[SKSpriteNode] = []
            for child in handleShapeNodes {
                index += 1
                let childLocation = CGPoint.init(x: child.position.x*2+self.handleNode.position.x,
                                                 y: child.position.y*2+self.handleNode.position.y)
                
                print("child location: \(child.position)")
                let shapeNodes = self.nodes(at: childLocation)
                for shapeNode in shapeNodes {
                    if self.isMapShape(shapeNode as! SKSpriteNode) && self.isMapInfo(shapeNode as! SKSpriteNode) {
                        countd += 1
                        tempAry.append(shapeNode as! SKSpriteNode)
                        
                    }
                }
            }
            
            // 如果都没有被填充
            if index == countd {
                for mapNode in tempAry {
                    mapNode.texture = texture
                    let mapInfo:MapModel = mapNode.userData?.object(forKey: "mapInfo") as! MapModel
                    mapInfo.isHave = true
                }
                self.shaderAry.remove(self.handleNode)
                self.handleNode.removeFromParent()
                self.shapeFill()
            } else {//只要有一个被填充
                let index = self.shaderAry.index(of: self.handleNode)
                let location = self.shaperPosAry[index]
                let scale = SKAction.scale(to: 1, duration: 0.2)
                let move = SKAction.move(to: location, duration: 0.2)
                let group = SKAction.group([scale,move])
                group.timingMode = .easeOut
                self.handleNode.run(group)
            }
            // 释放
            self.handleNode = nil
        
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
