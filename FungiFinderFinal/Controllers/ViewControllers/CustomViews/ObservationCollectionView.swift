//
//  ObservationCollectionView.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/11/21.
//

import UIKit

class ObservationCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var observationImageView: UIImageView!
    @IBOutlet weak var observationNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    func displayNameFor(observation: Observation) {
        observationNameLabel.text = observation.name
        dateLabel.text = observation.date?.dateAsString()
       observationNameLabel.backgroundColor = UIColor(white: 1, alpha: 0.65)
        dateLabel.backgroundColor = UIColor(white: 1, alpha: 0.65)
    }
    
    func displayImageFor(observation: Observation) {
        if let data = observation.image {
            observationImageView.image = UIImage(data: data)
            }
        observationImageView.contentMode = .scaleAspectFill
    }
}// End of Class
