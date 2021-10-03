//
//  HomeViewController.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/5/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var mushroomListButton: UIButton!
    @IBOutlet weak var observationsButton: UIButton!
    @IBOutlet weak var shroomMapButton: UIButton!
    
    let userLicenseAgreement  = """
    Disclaimer! Never eat any mushroom without the help of a professional. Some mushrooms may be tasty, but plenty can be deadly. While Fungi Finder can be used as a supplimental source for educational identificaiton, judgement should never be decided based on one source alone.
    """
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(!appDelegate.hasAlreadyLaunched){
            //set hasAlreadyLaunched to false
            appDelegate.sethasAlreadyLaunched()
            //display user agreement license
            displayLicenAgreement(message: self.userLicenseAgreement)
        }
    }
    
    //MARK: - METHODS
    
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
    
    func displayLicenAgreement(message:String){
        //create alert
        let alert = UIAlertController(title: "License Agreement", message: message, preferredStyle: .alert)
        //create Decline button
        let declineAction = UIAlertAction(title: "Decline" , style: .destructive){ (action) -> Void in
        }
        //create Accept button
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { (action) -> Void in
        }
        //add task to tableview buttons
        alert.addAction(declineAction)
        alert.addAction(acceptAction)
        self.present(alert, animated: true, completion: nil)
    }
} // End of Class
