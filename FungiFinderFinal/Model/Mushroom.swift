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
    let shroomSubDescription: String?
    let citation: String
    let cCTitle: String?
    let cC: String?
    let hyperLink: String?
    let cCLicense: String?
    let wiki: String?
    let wikiCc: String?
    
    init(name: String, nickname: String, image: UIImage, hymeniumType: String, capShape: String, whichGills: String, stipeCharacter: String, sporePrintColor: String, howEdible: String, season: String, shroomDescription: String, shroomSubDescription: String?, citation: String, cCTitle: String?, cC: String?, hyperLink: String?, cCLicense: String?, wiki: String?, wikiCc: String?) {
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
        self.shroomSubDescription = shroomSubDescription
        self.citation = citation
        self.cCTitle = cCTitle
        self.cC = cC
        self.hyperLink = hyperLink
        self.cCLicense = cCLicense
        self.wiki = wiki
        self.wikiCc = wikiCc
    }
} // End of Class

extension Mushroom: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        if name.lowercased().contains(searchTerm.lowercased()) || nickname.lowercased().contains(searchTerm.lowercased()) {
            return true
        } else {
            return false
        }
    }
} // End of Extension
