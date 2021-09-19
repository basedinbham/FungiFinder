//
//  MapViewController.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/5/21.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet private var mapView: MKMapView!
    
    //MARK: - PROPERTIES
    // Gets location of device
    let manager = CLLocationManager()
    var observations: [Observation]?
    var currentlySelectedObservation: Observation?
    
    //MARK: - LIFECYCLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupViews()
        fetchObservations()
        
    }
    
    //MARK: - FETCH
    
    func fetchObservations() {
        ObservationController.shared.fetchOBservations()
        
        self.observations = ObservationController.shared.observations
    }
    
    //MARK: - PERMISSIONS
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) -> Bool {
        var hasPermission = false
        switch manager.authorizationStatus {
        // App first launched, hasn't determined
        case .notDetermined:
            // For use when the app is open
            manager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            hasPermission = true
            break
        // For use when the app is open
        case .authorizedWhenInUse:
            hasPermission = true
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
        return hasPermission
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
        presentRequiredPermissions()
        // Allows reaction to touch on map (tap recognizer)
        //        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        //        gestureRecognizer.delegate = self
        //        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    // Required location persmission to access certain map based features
    func presentRequiredPermissions() {
        if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
            let alert = UIAlertController(title: "Location Permission Required", message: "Map features require access to Location Services. Please allow access to your location to use these features.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (cAlertAction) in
                //Redirect to Settings app
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            alert.addAction(cancelAction)
            alert.addAction(settingsAction)
            self.present(alert, animated: true)
        } else {
            return
        }
    }
    // Handles the tap & gets location coordinates
    //    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
    //
    //        let location = gestureRecognizer.location(in: mapView)
    //        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
    //
    //        // Add annotation(pin):
    //        let annotation = MKPointAnnotation()
    //        annotation.coordinate = coordinate
    //        mapView.addAnnotation(annotation)
    //annotation.title
    //annotation.subtitle
    //    }
    
    //MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toObsVC",
           let destination = segue.destination as? ObservationDetailViewController {
            destination.observation = self.currentlySelectedObservation
        }
    }
}// End of Class

//MARK: - DELEGATE EXTENIONS

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    // Delegate function; gets called when location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            render(location)
        }
    }
    // Zoom into map on location, & add pin
    func render(_ location: CLLocation) {
        fetchObservations()
        guard let observations = observations else { return }
        for observation in observations {
            let coordinate = CLLocationCoordinate2D(latitude: observation.latitude, longitude: observation.longitude)
            
            let pin = MKPointAnnotation()
            pin.coordinate = coordinate
            mapView.addAnnotation(pin)
            pin.title = observation.name
            pin.subtitle = observation.date?.dateAsString()
        }
        // The latitude and longitude associated with a location
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        // The width and height of a map region.
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        // Set maps region(view)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    // Set custom image for map pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotation")
        annotationView.image = #imageLiteral(resourceName: "fungiPoint2")
        annotationView.canShowCallout = true
        annotationView.calloutOffset = CGPoint(x: -5, y: 5)
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            // Cross-match locaiton for selected Annotation point with observation location
            guard let observations = observations else { return }
            for o in observations {
                let testLocation = CLLocationCoordinate2D(latitude: o.latitude, longitude: o.longitude)
                // If the annotation & observation have the same location run code below
                if testLocation.latitude == view.annotation!.coordinate.latitude && testLocation.longitude == view.annotation!.coordinate.longitude {
                    // segue to observation detail VC
                    self.currentlySelectedObservation = o
                    performSegue(withIdentifier: "toObsVC", sender: view)
                    break
                }
            }
        }
    }
}// End of Extension
