//
//  ViewController.swift
//  Paint
//
//  Created by Alim on 16.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var customView: CustomView!
    @IBOutlet weak var undoButton: UIButton!
    var shapes: Array<Shapes> = [.circle, .rectangle, .line, .triangle, .pencil]
    var colors: Array<UIColor> = [.green, .blue, .orange, .systemPink, .purple, .red, .systemTeal, .yellow]
    
    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tap))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(long))
        tapGesture.numberOfTapsRequired = 1
        undoButton.addGestureRecognizer(tapGesture)
        undoButton.addGestureRecognizer(longGesture)
    }

    @objc func tap() {
        if Settings.figures.count > 0 {
            Settings.figures.removeLast()
            customView.setNeedsDisplay()
        }
    }

    @objc func long() {
        if Settings.figures.count > 0 {
            Settings.figures.removeAll()
            customView.setNeedsDisplay()
        }
    }

    @IBAction func shapePressed(_ sender: UIButton) {
        Settings.shape = shapes[sender.tag]
    }
    
    @IBAction func fillingPressed(_ sender: UISwitch) {
        Settings.isFilled = sender.isOn
    }
    
    @IBAction func colorPressed(_ sender: UIButton) {
        Settings.color = colors[sender.tag]
    }
}

