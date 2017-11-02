//
//  OutputView.swift
//  CoordinateCalculator
//
//  Created by Mrlee on 2017. 11. 2..
//  Copyright © 2017년 Codesquad Inc. All rights reserved.
//

import Foundation
let middleDot = "\u{00B7}"

struct OutputView {
    static func drawAxis() {
        // (10, 10)
        let x1: Int = (24 * 2) + 3 // 0 ~ 24
        let y1: Int = 24 // 0 ~ 24
        
        print("\(ANSICode.clear)\(ANSICode.home)")
        print("\(ANSICode.cursor.move(row:y1, col: x1))\(ANSICode.text.redBright)\(middleDot)")
        print("\(ANSICode.text.whiteBright)\(ANSICode.axis.draw())")
    }
    
}


