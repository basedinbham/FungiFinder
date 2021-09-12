//
//  MushroomDetailViewController.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/5/21.
//

import UIKit

class MushroomDetailViewController: UIViewController {
    
    //MARK: - LABELS
    @IBOutlet weak var mushroomImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var howEdibleLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var subDescriptionLabel: UILabel!
    @IBOutlet weak var citationLabel: UILabel!
    
    //MARK: - PROPERTIES
    var mushroom: Mushroom? {
        didSet{
            updateViews()
        }
    }
    
    //MARK: - LIFECYCLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - METHODS
    
    func updateViews() {
        guard let mushroom = mushroom else { return }
        mushroomImage?.image = mushroom.image
        nameLabel?.text = mushroom.name
        nicknameLabel?.text = mushroom.nickname
        howEdibleLabel?.text = mushroom.howEdible
        seasonLabel?.text = mushroom.season
        descriptionLabel?.text = mushroom.shroomDescription
        subDescriptionLabel?.text = mushroom.shroomSubDescription
        citationLabel?.text = mushroom.citation
        
//
//        if let image = UIImage(data:mushroom.image!) {
//            DispatchQueue.main.async {
//                 self.mushroomImage.image = image
//            }
//        }
        
    }
} // End of Class
