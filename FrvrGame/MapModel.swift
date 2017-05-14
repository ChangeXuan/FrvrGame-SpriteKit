//
//  MapModel.swift
//  FrvrGame
//
//  Created by 覃子轩 on 2017/5/14.
//  Copyright © 2017年 覃子轩. All rights reserved.
//

import UIKit

class MapModel {
    var location:CGPoint = CGPoint()
    var position:CGPoint = CGPoint()
    var serialNumber:Int = 0
    var adjacentArry:[String] = []
    var isHave:Bool = false
    init(location:CGPoint,position:CGPoint,serialNumber:Int,adjacentArry:[String],isHave:Bool) {
        self.location = location
        self.position = position
        self.serialNumber = serialNumber
        self.adjacentArry = adjacentArry
        self.isHave = isHave
    }
}
