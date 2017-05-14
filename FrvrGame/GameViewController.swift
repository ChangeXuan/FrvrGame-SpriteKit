//
//  GameViewController.swift
//  FrvrGame
//
//  Created by 覃子轩 on 2017/5/13.
//  Copyright © 2017年 覃子轩. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置游戏场景显示的大小
        let sceneNode = GameScene(size: view.frame.size)
        
        if let view = self.view as! SKView? {
            view.presentScene(sceneNode)
            // 设置为true时，同一个Z深度的子节点的顺序不会被保证
            view.ignoresSiblingOrder = true
            // 显示物理实体,多用于测试
            view.showsPhysics = false
            // 显示帧率
            view.showsFPS = true
            // 显示节点(精灵)的数量
            view.showsNodeCount = true
        }
        
//        if let view = self.view as! SKView? {
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = SKScene(fileNamed: "GameScene") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//                
//                // Present the scene
//                view.presentScene(scene)
//            }
//            view.ignoresSiblingOrder = true
//            view.showsFPS = true
//            view.showsNodeCount = true
//        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
