//
//  Month.swift
//  TuneIn
//
//  Created by Tamas Bara on 26.01.22.
//

import Foundation

struct Month: Hashable {
    
    var title: String
    var entriesCount: Int
    var rockEntriesCount: Int
    
    var entries: String {
        
        guard entriesCount > 0 else { return "" }
        
        if entriesCount > 1 {
            return "\(entriesCount) Einträge"
        }
        
        return "\(entriesCount) Eintrag"
    }
    
    var rockEntries: String {
        
        guard rockEntriesCount > 0 else { return "" }
        
        if rockEntriesCount > 1 {
            return "\(rockEntriesCount) Felstage"
        }
        
        return "\(rockEntriesCount) Felstag"
    }
}

func <(lhs: Month, rhs: Month) -> Bool {
    let months = ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"]
    guard let month1 = lhs.title.components(separatedBy: " ").first,
          let month2 = rhs.title.components(separatedBy: " ").first,
          let index1 = months.firstIndex(of: month1),
          let index2 = months.firstIndex(of: month2) else { return false }
    
    return index1 < index2
}
