//
//  ObservationController.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/5/21.
//

import CoreData
import UIKit

class ObservationController {
    
    static let shared = ObservationController()
    var observations: [Observation] = []
    let privateDB = CKContainer.default().privateCloudDatabase
    
    private lazy var fetchRequest: NSFetchRequest<Observation> = {
        let request = NSFetchRequest<Observation>(entityName: "Observation")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    //MARK: - CRUD
    
    /// <#Description#>
    /// - Parameters:
    ///   - name: Name of the observation.
    ///   - date: Date the observation was saved.
    ///   - notes: Notes saved for the observation.
    ///   - reminder: Date set for a reminder.
    ///   - type: Type of mushroom suspected.
    ///   - latitude: Latitude location for observation.
    ///   - longitude: Longitude location for observation.
    ///   - locationIsOn: Bool for location status.
    func createObservation(with name: String, image: UIImage?, date: Date, notes: String, reminder: Date, type: String, latitude: Double, longitude: Double, locationIsOn: Bool = true) {
        let observation = Observation(date: date, image: image, latitude: latitude, longitude: longitude, name: name, notes: notes, reminder: reminder, type: type, locationIsOn: locationIsOn)
        observations.append(observation)
        CoreDataStack.saveContext()
        NotificationManager.shared.scheduleNotification(observation: observation)
    }
    
    func fetchOBservations() {
        let observations = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
        let observationSorted = observations.sorted(by: { $0.date ?? Date() > $1.date ?? Date() } )
        self.observations = observationSorted
    }
    
    func updateObservation(_ observation: Observation, name: String, date: Date, image: UIImage?, notes: String, reminder: Date, type: String, latitude: Double, longitude: Double, locationIsOn: Bool = true) {
        observation.name = name
        observation.date = date
        if observation.image != nil {
            observation.image = observation.image
        } else {
        observation.image = image?.jpegData(compressionQuality: 1.0)
        }
        observation.notes = notes
        observation.reminder = reminder
        observation.type = type
        observation.latitude = latitude
        observation.longitude = longitude
        observation.locationIsOn = locationIsOn
        NotificationManager.shared.removeScheduledNotification(observation: observation)
        NotificationManager.shared.scheduleNotification(observation: observation)
        
        CoreDataStack.saveContext()
    }
    
    func deleteObservation(observation: Observation) {
        if let index = observations.firstIndex(of: observation) {
            observations.remove(at: index)
            CoreDataStack.context.delete(observation)
            CoreDataStack.saveContext()
            NotificationManager.shared.removeScheduledNotification(observation: observation)
        }
    }
} // End of Class
