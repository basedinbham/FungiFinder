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
    @IBOutlet weak var cCTextView: UITextView!
    
    //MARK: - PROPERTIES
    var mushroom: Mushroom? {
        didSet{
            updateViews()
            textLink()
        }
    }
    
    //MARK: - LIFECYCLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        textLink()
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
        //cCTextView?.text = mushroom

        }
    
    func textLink() {
        guard let mushroom = mushroom else { return }
        let attributedString = NSMutableAttributedString(string: mushroom.hyperLink ?? "" )
        let url = URL(string: mushroom.hyperLink ?? "")!

    // Set the 'click here' substring to be the link
    attributedString.setAttributes([.link: url], range: NSMakeRange(0, 0))

        cCTextView?.attributedText = attributedString
        cCTextView?.isUserInteractionEnabled = true
        cCTextView?.isEditable = false

    // Set how links should appear: blue and underlined
        cCTextView?.linkTextAttributes = [
        .foregroundColor: UIColor.blue,
        .underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    }

//
//        if let image = UIImage(data:mushroom.image!) {
//            DispatchQueue.main.async {
//                 self.mushroomImage.image = image
//            }
//        }
} // End of Class
