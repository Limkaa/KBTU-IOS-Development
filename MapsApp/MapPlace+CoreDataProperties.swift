//
//  MapPlace+CoreDataProperties.swift
//  MapsApp
//
//  Created by Alim on 25.03.2021.
//
//

import Foundation
import CoreData
import MapKit


extension MapPlace {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MapPlace> {
        return NSFetchRequest<MapPlace>(entityName: "MapPlace")
    }

    @NSManaged public var annonation: MKPointAnnotation
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double

}

extension MapPlace : Identifiable {

}
