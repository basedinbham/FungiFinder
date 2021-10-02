//
//  DateAsString.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/7/21.
//

import Foundation
 
extension Date {
    
    func dateAsString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = . short
        
        return formatter.string(from: self)
    }
    
}
