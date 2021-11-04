//
//  TypeButton.swift
//  Fungi Finder
//
//  Created by Kyle Warren on 11/3/21.
//

import UIKit

class typeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.font = UIFont(name: "Helvetica", size: 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
}

