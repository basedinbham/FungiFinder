//
//  SearchableResults.swift
//  Fungi Finder
//
//  Created by Kyle Warren on 10/5/21.
//

import Foundation

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
} // End of Protocol
