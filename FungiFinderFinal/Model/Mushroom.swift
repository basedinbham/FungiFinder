//
//  Mushroom.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/5/21.
//

import UIKit

class Mushroom {
    let name: String
    let nickname: String
    let image: UIImage
    let hymeniumType: String
    let capShape: String
    let whichGills: String
    let stipeCharacter: String
    let sporePrintColor: String
    let howEdible: String
    let season: String
    let shroomDescription: String
    
    init(name: String, nickname: String, image: UIImage, hymeniumType: String, capShape: String, whichGills: String, stipeCharacter: String, sporePrintColor: String, howEdible: String, season: String, shroomDescription: String) {
        self.name = name
        self.nickname = nickname
        self.image = image
        self.hymeniumType = hymeniumType
        self.capShape = capShape
        self.whichGills = whichGills
        self.stipeCharacter = stipeCharacter
        self.sporePrintColor = sporePrintColor
        self.howEdible = howEdible
        self.season = season
        self.shroomDescription = shroomDescription
    }
}// End of Class
