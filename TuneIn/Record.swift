//
//  Record.swift
//  TuneIn
//
//  Created by Tamas Bara on 26.01.22.
//

import FirebaseFirestore

struct Record: Hashable {
    
    var id: String?
    var when: Date
    var wher: String
    var what: String
    var type: RecordType
    
    init() {
        when = Date()
        wher = ""
        what = ""
        type = .gym
    }
    
    init(id: String?, when: Date, wher: String, what: String, type: RecordType) {
        self.id = id
        self.when = when
        self.wher = wher
        self.what = what
        self.type = type
    }
    
    init?(document: QueryDocumentSnapshot) {
        
        guard let date = document["date"] as? Timestamp,
              let location = document["location"] as? String,
              let info = document["info"] as? String else { return nil }
        
        id = document.documentID
        when = date.dateValue()
        wher = location
        what = info
        type = RecordType(rawValue: document["type"] as? String ?? "") ?? .gym
    }
    
    var data: [String: Any] {
        return [
            "date": when,
            "location": wher,
            "info": what,
            "type": type.rawValue
        ]
    }
}
