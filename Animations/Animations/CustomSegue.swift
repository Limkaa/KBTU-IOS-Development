//
//  CustomSegue.swift
//  Animations
//
//  Created by Alim on 29.03.2021.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    
    override func perform() {
        scale()
    }
    
    func scale() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        toViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        toViewController.view.center = originalCenter
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            toViewController.view.transform = CGAffineTransform.identity
            fromViewController.view.alpha = 0
        }, completion: { success in
            toViewController.modalPresentationStyle = .fullScreen
            fromViewController.present(toViewController, animated: false, completion: nil)
        })
    }
}
