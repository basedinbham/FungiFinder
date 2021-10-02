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
} // End of Class
