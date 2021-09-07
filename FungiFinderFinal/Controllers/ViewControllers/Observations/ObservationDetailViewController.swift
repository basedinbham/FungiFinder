//
//  ObservationDetailViewController.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/5/21.
//

import UIKit
import CoreLocation
import MapKit

class ObservationDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var reminderPicker: UIDatePicker!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var saveLocationSwitch: UISwitch!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    //MARK: - PROPERTIES
    var observation: Observation?
    var location: CLLocation?
    // Gets location of device
    let manager = CLLocationManager()
    var saveLat: Double?
    var saveLong: Double?
    var switchLat: Double?
    var switchLong: Double?
    
    //MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        setupViews()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    //MARK: - ACTIONS
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
              let notes = notesTextField.text, !notes.isEmpty,
              let type = typeTextField.text, !type.isEmpty else { return }
        let latitude = observation?.latitude
        let longitude = observation?.latitude
        
        if let observation = observation {
            ObservationController.shared.updateObservation(observation, name: name, date: datePicker.date, notes: notes, reminder: reminderPicker.date, type: type, latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
        } else {
            ObservationController.shared.createObservation(with: name, date: datePicker.date, notes: notes, reminder: reminderPicker.date, type: type, latitude: switchLat ?? 0.0, longitude: switchLong ?? 0.0)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveLocationSwitchTapped(_ sender: Any) {
        if saveLocationSwitch.isOn == true {
            switchLat = saveLat
            switchLong = saveLong
            mapView.isHidden = false
        } else if saveLocationSwitch.isOn == false {
            mapView.isHidden = true
            return
        }
    }
   
    @IBAction func selectImageButtonTapped(_ sender: Any) {
        
    }
    
    //MARK: - PERMISSIONS
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        // App first launched, hasn't determined
        case .notDetermined:
            // For use when the app is open, & in the background
            manager.requestAlwaysAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
        // For use when the app is open
        case .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
        
        switch manager.accuracyAuthorization {
        
        case .fullAccuracy:
            break
        case .reducedAccuracy:
            break
        @unknown default:
            break
        }
        // This will update us along the way, as the user has our app
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Status is the outcome of our ability to use their location, where were checking if there's been changes
        switch status {
        case .restricted:
            print("\nUsers location is restricted")
            
        case .denied:
            print("\nUser denied access to use their location\n")
            
        case .authorizedWhenInUse:
            print("\nuser granted authorizedWhenInUse\n")
            
        case .authorizedAlways:
            print("\nuser selected authorizedAlways\n")
            
        default: break
        }
    }
    
    
    //MARK: - HELPER METHODS
    func updateViews() {
        guard let observation = observation else { return }
        nameTextField.text = observation.name
        datePicker.date = observation.date ?? Date()
        notesTextField.text = observation.notes
        reminderPicker.date = observation.reminder ?? Date()
        typeTextField.text = observation.type
        latitudeLabel.text = String(observation.latitude)
        longitudeLabel.text = String(observation.longitude)
    }
    
    //MARK: - HELPER METHODS
        func setupViews() {
            // Set accuracy for location
            manager.desiredAccuracy = kCLLocationAccuracyBest
            // set delegate for location
            manager.delegate = self
            // Request permission
            manager.requestWhenInUseAuthorization()
            // Fetch location
            manager.startUpdatingLocation()
            // Set delegate for mapView
            mapView.delegate = self
        }
    
    // Delegate function; gets called when location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let userLocation = location.coordinate

            saveLat = userLocation.latitude
            saveLong = userLocation.longitude
            
            manager.stopUpdatingLocation()
            
            render(location)
        }
    }
    
    // Zoom into map on location
    func render(_ location: CLLocation) {
        // If there is an Observation, display stored locaiton.
        if let observation = observation {
            let coordinate = CLLocationCoordinate2D(latitude: observation.latitude, longitude: observation.longitude)
            // The width and height of a map region.
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            // Set maps region(view)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
            // Creates annotation(pin)
            let pin = MKPointAnnotation()
            pin.coordinate = coordinate
            mapView.addAnnotation(pin)
            // If there isn't a current Observation, a new one is being created.  Display current locaiton.
        } else {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        // The width and height of a map region.
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        // Set maps region(view)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
            // Creates annotation(pin)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
}
    // Set custom image for map pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotation")
        annotationView.image = #imageLiteral(resourceName: "fungiPoint2")
        annotationView.canShowCallout = true
        return annotationView
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}// End of Class

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}// End of Extension
