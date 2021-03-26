//
//  ViewController.swift
//  MapsApp
//
//  Created by Alim on 21.03.2021.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, updateMap {
    
    // Necessary variables
    var mapType: [Int: MKMapType] = [0: .standard, 1: .satellite, 2: .hybrid]
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var places: [MapPlace] = []
    var displayedPlaceIndex = 0
    var placesDisplayed = false

    
    // UI Elements according to the storyboard
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentedControlPAnel: UISegmentedControl!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    // Additianal initialization of UI elements as places table, blured backgrounds
    let placesBlurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let segmentedControl: UISegmentedControl = {
        let sg = UISegmentedControl(items: ["Standart", "Satellite", "Hybrid"])
        return sg
    }()
    
    let placesTable: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "placeCell")
        return table
    }()
    
    
    // Setuping the screen after loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesTable.dataSource = self
        placesTable.delegate = self
        
        mapView.mapType = .standard
        mapView.delegate = self
        
        let blurEffect = UIBlurEffect(style: .light)
        view.addSubview(blurView)
        blurView.effect = blurEffect
        setupBottomBlurView()
        
        view.addSubview(segmentedControlPAnel)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        fetchPlaces()
        setupMapPlaces()
    }
    
    
    // Setuping the bottom view begind segmented control and switching buttons
    fileprivate func setupBottomBlurView() {
        blurView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        blurView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    
    // Setuping the places table and blured background behind it
    fileprivate func setupPlacesBlurView() {
        if !placesDisplayed {
            let blurEffect = UIBlurEffect(style: .light)
            view.addSubview(placesBlurView)
            placesBlurView.effect = blurEffect
            placesBlurView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            placesBlurView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            placesBlurView.bottomAnchor.constraint(equalTo: blurView.topAnchor).isActive = true
            placesBlurView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            
            view.addSubview(placesTable)
            placesTable.translatesAutoresizingMaskIntoConstraints = false
            placesTable.leftAnchor.constraint(equalTo: placesBlurView.leftAnchor).isActive = true
            placesTable.rightAnchor.constraint(equalTo: placesBlurView.rightAnchor).isActive = true
            placesTable.bottomAnchor.constraint(equalTo: placesBlurView.bottomAnchor).isActive = true
            placesTable.topAnchor.constraint(equalTo: placesBlurView.topAnchor).isActive = true
            placesTable.backgroundColor = .clear
            placesTable.separatorStyle = .none
            
            placesDisplayed = true
            
        } else {
            placesTable.removeFromSuperview()
            placesBlurView.removeFromSuperview()
            placesDisplayed = false
        }
    }
    
    // Fetching information from Core Data
    func fetchPlaces() {
        self.places = try! context.fetch(MapPlace.fetchRequest())
    }
    
    // Updating map information
    func updateMap() {
        mapView.removeAnnotations(mapView.annotations)
        fetchPlaces()
        setupMapPlaces()
    }
    
    // Setuping annotations on the map
    func setupMapPlaces() {
        fetchPlaces()
        mapView.removeAnnotations(mapView.annotations)
        for place in places {
            place.annonation.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            mapView.addAnnotation(place.annonation)
        }
    }
    
    // Process changing of the segmented control
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        mapView.mapType = mapType[sender.selectedSegmentIndex] ?? .standard
    }
    
    
    // Process folder button click in navigation bar
    @IBAction func folderPressed(_ sender: UIBarButtonItem) {
        setupPlacesBlurView()
        fetchPlaces()
        placesTable.reloadData()
        setupMapPlaces()
    }
    
    // Function for moving map focus to some point on the map
    func moveMapViewTo(annotation: MKPointAnnotation) {
        mapView.setCenter(annotation.coordinate, animated: true)
        navigationBar.title = title
    }
    
    
    // Process next button click
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        displayedPlaceIndex += 1
        if places.count > 0 {
            if displayedPlaceIndex < places.count {
                let place = places[displayedPlaceIndex]
                moveMapViewTo(annotation: place.annonation)
                navigationBar.title = place.annonation.title
            } else {
                displayedPlaceIndex = 0
                let place = places[displayedPlaceIndex]
                moveMapViewTo(annotation: place.annonation)
                navigationBar.title = place.annonation.title
            }
        }
        
    }
    
    
    // Process previous button click
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        displayedPlaceIndex -= 1
        if places.count > 0 {
            if displayedPlaceIndex >= 0 {
                let place = places[displayedPlaceIndex]
                moveMapViewTo(annotation: place.annonation)
                navigationBar.title = place.annonation.title
            } else {
                displayedPlaceIndex = places.count - 1
                let place = places[displayedPlaceIndex]
                moveMapViewTo(annotation: place.annonation)
                navigationBar.title = place.annonation.title
            }
        }
    }
    
    
    // Process long tap on the map
    @IBAction func longTap(_ sender: UILongPressGestureRecognizer) {
        
        let touchPoint = sender.location(in: self.mapView)
        let coordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        
        let alertController = UIAlertController(title: "Add place", message: "Fill the fields", preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Enter title"
        }
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Enter subtitle"
        }
        
        let save = UIAlertAction(title: "Add", style: .default) { [weak self](alert) in
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            
            let annotation = MKPointAnnotation()
            annotation.title = firstTextField.text
            annotation.subtitle = secondTextField.text
            
            let newPlace = MapPlace(context: self!.context)
            newPlace.annonation = annotation
            newPlace.latitude = coordinate.latitude
            newPlace.longitude = coordinate.longitude

            try! self!.context.save()
            self!.setupMapPlaces()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(save)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // Process simple tap on the map
    @IBAction func simpleTapOnMap(_ sender: UITapGestureRecognizer) {
        navigationBar.title = ""
    }
    
    
    // Number of places for displaying in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchPlaces()
        return places.count
    }
    
    // Information and formatting style for table cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = placesTable.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "reuseIdentifier")
        }
        let place = places[indexPath.row]
        cell?.textLabel?.text = place.annonation.title
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 25.0)
        cell?.detailTextLabel?.text = place.annonation.subtitle
        cell?.detailTextLabel?.font = UIFont(name:"Arial", size:22)
        cell?.backgroundColor = .clear
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    
    // Process selecting of the table cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        moveMapViewTo(annotation: place.annonation)
        navigationBar.title = place.annonation.title
        setupPlacesBlurView()
    }
    
    
    // Process table cell deleting by swiping
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let placeToRemove = places[indexPath.row]
            self.context.delete(placeToRemove)
            try! self.context.save()
            
            placesTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // Process pressing on info button in annotation
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditPlaceViewController") as? EditPlaceViewController
        displayedPlaceIndex = places.lastIndex(where: {$0.annonation === view.annotation}) ?? 0
        vc?.place = places[displayedPlaceIndex]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}


// Custom class for annotation view with enabling some functions
class CustomAnnotationView: MKPinAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        canShowCallout = true
        rightCalloutAccessoryView = UIButton(type: .infoLight)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

