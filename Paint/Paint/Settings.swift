//
//  Settings.swift
//  Paint
//
//  Created by Alim on 17.02.2021.
//

import Foundation
import UIKit

enum Shapes {
    case circle
    case rectangle
    case line
    case triangle
    case pencil
}

struct Settings {
    static var color: UIColor! = .green
    static var isFilled: Bool! = false
    static var strokeWidth: CGFloat! = 5
    static var shape: Shapes! = Shapes.circle
    static var figures: Array<Shape>! = []
}
