//
//  ObservationDetailViewController.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/5/21.
//

import UIKit
import CoreLocation
import MapKit

class ObservationDetailViewController: UIViewController, UITextViewDelegate, UNUserNotificationCenterDelegate {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notesTextField: UITextView!
    @IBOutlet weak var reminderPicker: UIDatePicker!
    @IBOutlet weak var typeTextField: UITextField!
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
    let imagePicker = UIImagePickerController()
    var observationImage: UIImage?
    
    
    //MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        setupViews()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupViews()
        
    }
    
    //MARK: - ACTIONS
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
              let notes = notesTextField.text, !notes.isEmpty,
              let type = typeTextField.text, !type.isEmpty else { presentRequiredTextAlert(); return }
        let latitude = saveLat
        let longitude = saveLong
        
        if let observation = observation {
            ObservationController.shared.updateObservation(observation, name: name, date: datePicker.date, image: observationImage, notes: notes, reminder: reminderPicker.date, type: type, latitude: latitude ?? 0.0, longitude: longitude ?? 0.0, locationIsOn: saveLocationSwitch.isOn)
        } else {
            ObservationController.shared.createObservation(with: name, image: observationImage, date: datePicker.date, notes: notes, reminder: reminderPicker.date, type: type, latitude: latitude ?? 0.0, longitude: longitude ?? 0.0, locationIsOn: saveLocationSwitch.isOn)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveLocationSwitchTapped(_ sender: Any) {
        if saveLocationSwitch.isOn == true && manager.authorizationStatus == .authorizedWhenInUse {
            mapView.isHidden = false
            observation?.locationIsOn = true
        } else if saveLocationSwitch.isOn == false ||  saveLocationSwitch.isOn == true && manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
            mapView.isHidden = true
            observation?.latitude = 0.0
            observation?.longitude = 0.0
            observation?.locationIsOn = false
            saveLocationSwitch.isOn = false
            presentRequiredPermissions()
            return
        }
    }
    
    @IBAction func selectImageButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add a photo", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.openGallery()
        }
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let observation = observation else { return }
        ObservationController.shared.deleteObservation(observation: observation)
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - PERMISSIONS
    
    func inquireNotifcationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            // If yes
            if granted {
                print("Permission for notifications was granted by user")
                UNUserNotificationCenter.current().delegate = self
            }
            // If there's an error
            if let error = error {
                print("There was an error with the notification permissions \(error.localizedDescription)")
            }
            
            // If not granted
            if !granted {
                print("Notification access was denied")
            }
        }
    }
    
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
    func updateViews() {
        guard let observation = observation else { return }
        nameTextField.text = observation.name
        datePicker.date = observation.date ?? Date()
        notesTextField.text = observation.notes
        reminderPicker.date = observation.reminder ?? Date()
        typeTextField.text = observation.type
        // If save location switch is set to on, let LocationIsOn property equal true
        saveLocationSwitch.isOn = observation.locationIsOn
        // If location is set to off hide the mapView
        mapView.isHidden = !observation.locationIsOn
        // Convert data to UIImage
        if let data = observation.image {
            photoImageView.image = UIImage(data: data)
            selectImageButton.setTitle("", for: .normal)
        }
        if observation.longitude == 0.0 {
            mapView.isHidden = true
            observation.locationIsOn = false
            saveLocationSwitch.isOn = false
        }
    }
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
        //delegate declaration for properties: imagePicker
        imagePicker.delegate = self
        notesTextField.delegate = self
        
        notesTextField.textColor = .lightGray
        notesTextField.text = "Place observation notes here..."
        notesTextField.backgroundColor = .white
        notesTextField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        notesTextField.layer.borderWidth = 1.0
        notesTextField.layer.cornerRadius = 8.0
        notesTextField.clipsToBounds = true
        
        mapView.layer.cornerRadius = 8.0
        mapView.clipsToBounds = true
        
        inquireNotifcationPermission()
    }
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        if notesTextField.textColor == .lightGray && notesTextField.isFirstResponder {
            notesTextField.text = ""
            notesTextField.textColor = .black
        }
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        if notesTextField.text.isEmpty || notesTextField.text == "" {
            notesTextField.textColor = .lightGray
            notesTextField.text = "Place observation notes here..."
        }
    }
    
    // Access to camera, or photo gallery
    func presentNoAccessAlert() {
        let alert = UIAlertController(title: "No Access", message: "Please allow access to use these features", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Back", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    // Required text to save an Observation
    func presentRequiredTextAlert() {
        let alert = UIAlertController(title: "Missing Fields", message: "Observations require a name, & type. These fields cannot be empty.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
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

//MARK: - DELEGATE EXTENSIONS

extension ObservationDetailViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
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
    /**
     
     # Render map for use with MapKit & MapView
     
     - Parameter location: Location must be of type CLLocation with **latitude**, & **longitude**.
     */
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
}

extension ObservationDetailViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    /// Opens users gallery for photo selection
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true)
        } else {
            self.presentNoAccessAlert()
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        } else {
            self.presentNoAccessAlert()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            photoImageView.image = editedImage
            
            // let jpegData = editedImage.jpegData(compressionQuality: 1.0)
            //observation?.image = jpegData
            observationImage = editedImage
            selectImageButton.setTitle("", for: .normal)
        } else if let pickedImage = info[.originalImage] as? UIImage {
            photoImageView.image = pickedImage
            
            //let jpegData = pickedImage.jpegData(compressionQuality: 1.0)
            //observation?.image = jpegData
            observationImage = pickedImage
            selectImageButton.setTitle("", for: .normal)
        }
        picker.dismiss(animated: true)
    }
} // End of Extension


