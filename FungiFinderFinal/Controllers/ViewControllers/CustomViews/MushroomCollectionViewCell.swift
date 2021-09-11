//
//  MushroomCollectionViewCell.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/10/21.
//

import UIKit

class MushroomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var shroomImageView: UIImageView!
    @IBOutlet weak var mushroomNameLabel: UILabel!
    @IBOutlet weak var mushroomNicknameLabel: UILabel!
    
    func displayNameFor(mushroom: Mushroom) {
        mushroomNameLabel.text = mushroom.name
        mushroomNicknameLabel.text = mushroom.nickname
        mushroomNameLabel.backgroundColor = UIColor(white: 1, alpha: 0.65)
        mushroomNicknameLabel.backgroundColor = UIColor(white: 1, alpha: 0.65)
    }
    
    func displayImageFor(mushroom: Mushroom) {
        shroomImageView.image = mushroom.image
        shroomImageView.contentMode = .scaleAspectFill
    }
    
}// End of Class
