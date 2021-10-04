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
    @IBOutlet weak var citationTextView: UITextView!
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
        textLinkWiki()
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
    }
    
    func textLink() {
        let creativeCommons = "https://creativecommons.org/licenses/by/3.0/?ref=ccsearch&atype=rich"
        
        guard let mushroom = mushroom else { return }
        let attributedString = NSMutableAttributedString(string:"\(mushroom.cCTitle ?? "")\(mushroom.cC ?? "")\(mushroom.cCLicense ?? "")")
        let url = URL(string: mushroom.hyperLink ?? "")!
        let url2 = URL(string: creativeCommons)
        
        // Set the 'click here' substring to be the link
        let wonkyCount = "\(mushroom.cCTitle ?? "")\(mushroom.cC ?? "")"
        attributedString.setAttributes([.link: url], range: NSMakeRange(0, mushroom.cCTitle?.count ?? 0))
        attributedString.setAttributes([.link: url2 ?? ""], range: NSMakeRange(wonkyCount.count , mushroom.cCLicense?.count ?? 0))
        
        cCTextView?.attributedText = attributedString
        cCTextView?.isUserInteractionEnabled = true
        cCTextView?.isEditable = false
        
        // Set how links should appear: blue and underlined
        cCTextView?.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        cCTextView?.font = UIFont.systemFont(ofSize: 10)
        cCTextView?.textColor = .label
        cCTextView?.isScrollEnabled = false
    }
    
    func textLinkWiki() {
        let creativeCommons = "https://creativecommons.org/licenses/by/3.0/?ref=ccsearch&atype=rich"
        
        guard let mushroom = mushroom else { return }
        let attributedString = NSMutableAttributedString(string:"\(mushroom.citation)\(mushroom.wikiCc ?? "")")
        let url = URL(string: mushroom.wiki ?? "")!
        let url2 = URL(string: creativeCommons)
        
        // Set the 'click here' substring to be the link
        attributedString.setAttributes([.link: url], range: NSMakeRange(54, mushroom.name.count))
        attributedString.setAttributes([.link: url2 ?? ""], range: NSMakeRange(mushroom.citation.count ,  53))
        
        
        citationTextView?.attributedText = attributedString
        citationTextView?.isUserInteractionEnabled = true
        
        // Set how links should appear: blue and underlined
        citationTextView?.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        citationTextView?.font = UIFont.systemFont(ofSize: 14)
        citationTextView?.textColor = .label
    }
} // End of Class


