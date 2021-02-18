//
//  CustomView.swift
//  Paint
//
//  Created by Alim on 16.02.2021.
//

import UIKit


class CustomView: UIView {
    
    var point1: CGPoint?
    var point2: CGPoint!
    
    override func draw(_ rect: CGRect) {
        for figure in Settings.figures {
            figure.drawPath()
        }
    }
    
    func addFigure() {
        if point1 != nil {
            let color = Settings.color
            let strokeWidth = Settings.strokeWidth
            let isFilled = Settings.isFilled
            
            switch Settings.shape {
            case .circle:
                let radius = abs(point2.x - point1!.x)/2
                let center = CGPoint(x:(point2.x + point1!.x)/2, y:(point2.y + point1!.y)/2)
                let circle = Circle(radius, center, color!, strokeWidth!, isFilled!)
                Settings.figures.append(circle)
                
            case .rectangle:
                let pointOne = CGPoint(x: min(point1!.x, point2.x), y: min(point1!.y, point2.y))
                let pointTwo = CGPoint(x: max(point1!.x, point2.x), y: max(point1!.y, point2.y))
                let rectangle = Rectangle(pointOne, pointTwo, color!, strokeWidth!, isFilled!)
                Settings.figures.append(rectangle)
                
            case .line:
                let line = Line(point1!, point2, color!, strokeWidth!)
                Settings.figures.append(line)
                
            case .triangle:
                let pointOne = CGPoint(x: min(point1!.x, point2.x), y: min(point1!.y, point2.y))
                let pointTwo = CGPoint(x: max(point1!.x, point2.x), y: max(point1!.y, point2.y))
                let triangle = Triangle(pointOne, pointTwo, color!, strokeWidth!, isFilled!)
                Settings.figures.append(triangle)
            
            case .pencil:
                let line = Line(point1!, point2, color!, strokeWidth!)
                Settings.figures.append(line)
                
            default:
                break
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            point1 = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if Settings.shape == Shapes.pencil {
                point2 = touch.location(in: self)
                addFigure()
                point1 = point2
                setNeedsDisplay()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            point2 = touch.location(in: self)
        }
        addFigure()
        setNeedsDisplay()
    }
}

protocol Shape {
    func drawPath()
}


extension Double {
    var cg: CGFloat {
        return CGFloat(self)
    }
}
