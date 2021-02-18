//
//  Line.swift
//  Paint
//
//  Created by Alim on 18.02.2021.
//

import Foundation
import UIKit

class Line: Shape {
    private var p1: CGPoint
    private var p2: CGPoint
    private var color: UIColor
    private var strokeWidth: CGFloat = 0.0
    
    init(_ p1: CGPoint,_ p2: CGPoint,_ color: UIColor,_ strokeWidth: CGFloat) {
        self.p1 = p1
        self.p2 = p2
        self.color = color
        self.strokeWidth = strokeWidth
    }
    
    func drawPath() {
        let linePath = UIBezierPath()
        linePath.move(to: p1)
        linePath.addLine(to: p2)
        
        linePath.lineWidth = strokeWidth
        color.set()
        linePath.stroke()
    }
}
