//
//  HomeViewController.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/5/21.
//

import UIKit

class HomeViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet weak var mushroomListButton: UIButton!
    @IBOutlet weak var observationsButton: UIButton!
    @IBOutlet weak var shroomMapButton: UIButton!
    
    
    
    //MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        inquireNotifcationPermission()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
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
    
    func setupViews() {
        mushroomListButton.layer.cornerRadius = 8.0
        mushroomListButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mushroomListButton.layer.borderWidth = 1
        mushroomListButton.clipsToBounds = true
        observationsButton.layer.cornerRadius = 8.0
        observationsButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        observationsButton.layer.borderWidth = 1
        observationsButton.clipsToBounds =  true
        shroomMapButton.layer.cornerRadius = 8.0
        shroomMapButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        shroomMapButton.layer.borderWidth = 1.0
        shroomMapButton.clipsToBounds = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

} // End of Class
