//
//  Observation+Convenience.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/5/21.
//

import CoreData
import UIKit
import MapKit

extension Observation: MKAnnotation {
    
    convenience init(date: Date, image: UIImage?, latitude: Double, longitude: Double, name: String, notes: String?, reminder: Date?, type: String, locationIsOn: Bool = true, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.date = date
        self.image = image?.jpegData(compressionQuality: 0.3) 
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.notes = notes
        self.reminder = reminder
        self.type = type
        self.id = UUID()
        self.locationIsOn = locationIsOn
    }
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude as Double, longitude: longitude as Double)
    }
}// End of Extension
