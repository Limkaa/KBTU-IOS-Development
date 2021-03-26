//
//  EditPlaceViewController.swift
//  MapsApp
//
//  Created by Alim on 21.03.2021.
//

import UIKit
import MapKit

protocol updateMap {
    func updateMap()
}

class EditPlaceViewController: UIViewController {

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var placeTitle: UITextField!
    @IBOutlet weak var placeDescription: UITextField!
    var place: MapPlace?
    var delegate: updateMap?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeTitle.text = place?.annonation.title
        placeDescription.text = place?.annonation.subtitle
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        let newAnnotation = MKPointAnnotation()
        newAnnotation.title = placeTitle.text
        newAnnotation.subtitle = placeDescription.text
        place?.annonation = newAnnotation
        try! self.context.save()
        delegate?.updateMap()
        navigationController?.popViewController(animated: true)
    }

}
