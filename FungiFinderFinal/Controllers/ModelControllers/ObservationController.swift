//
//  ObservationController.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/5/21.
//

import CoreData

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
    
    func createObservation(with name: String, date: Date, notes: String, reminder: Date, type: String, latitude: Double, longitude: Double) {
        let observation = Observation(date: date, image: nil, latitude: latitude, longitude: longitude, name: name, notes: notes, reminder: reminder, type: type)
        observations.append(observation)
        CoreDataStack.saveContext()
    }
    
    func fetchOBservations() {
        let observations = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
        self.observations = observations

    }
    
    func updateObservation(_ observation: Observation, name: String, date: Date, notes: String, reminder: Date, type: String, latitude: Double, longitude: Double) {
        observation.name = name
        observation.date = date
        observation.notes = notes
        observation.reminder = reminder
        observation.type = type
        observation.latitude = latitude
        observation.longitude = longitude
        
        CoreDataStack.saveContext()
    }
    
    func deleteObservation(observation: Observation) {
        if let index = observations.firstIndex(of: observation) {
            observations.remove(at: index)
            CoreDataStack.context.delete(observation)
            CoreDataStack.saveContext()
        }
    }
}// End of Class
