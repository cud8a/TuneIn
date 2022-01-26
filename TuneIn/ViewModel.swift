//
//  ViewModel.swift
//  TuneIn
//
//  Created by Tamas Bara on 25.01.22.
//

import SwiftUI
import FirebaseFirestore

class ViewModel: ObservableObject {
    
    var editorMode: EditorView.Mode = .edit
    
    private let collection = "Records"
    private var snapshot: QuerySnapshot?
    private var allRecords: [Record] = []
    
    @Published var months: [Month] = []
    
    @Published var newRecord: Record? {
        didSet {
            if newRecord != nil {
                editorMode = .add
                editedRecord = nil
            }
        }
    }
    
    @Published var editedRecord: Record? {
        didSet {
            if editedRecord != nil {
                editorMode = .edit
                newRecord = nil
            }
        }
    }
    
    var showMonth: Month?
    var records: [Record] {
        allRecords.filter({ $0.when.title == showMonth?.title })
    }
    
    var record: Record? {
        editedRecord == nil ? newRecord : editedRecord
    }
    
    init() {
        loadRecords()
    }
    
    func save() {
        let db = Firestore.firestore()
        switch editorMode {
        case .add:
            if let record = newRecord {
                var ref: DocumentReference? = nil
                ref = db.collection(collection).addDocument(data: record.data) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added with ID: \(ref?.documentID)")
                        self.loadRecords()
                    }
                }
            }
        default:
            if let record = editedRecord, let ref = snapshot?.documents.first(where: { $0.documentID == record.id })?.reference {
                ref.updateData(record.data) { error in
                    if let error = error {
                        print("Error editing document: \(error)")
                    } else {
                        print("Document updated with ID: \(ref.documentID)")
                        self.loadRecords()
                    }
                }
            }
        }
    }
    
    func delete() {
        if let ref = snapshot?.documents.first(where: { $0.documentID == editedRecord?.id })?.reference {
            ref.delete() { error in
                if let error = error {
                    print("Error editing document: \(error)")
                } else {
                    print("Document deleted with ID: \(ref.documentID)")
                    self.loadRecords()
                }
            }
        }
    }
    
    func loadRecords() {
        let db = Firestore.firestore()
        db.collection(collection).order(by: "date").getDocuments() { [weak self] querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self?.snapshot = querySnapshot
                self?.allRecords = querySnapshot?.documents.compactMap({ Record(document: $0) }).reversed() ?? []
                self?.setMonths()
            }
        }
    }
    
    private func setMonths() {
        var map: [String: Month] = [:]
        allRecords.forEach {
            let title = $0.when.title
            if map[title] == nil {
                map[title] = Month(title: title, entriesCount: 1, rockEntriesCount: $0.type == .rock ? 1 : 0)
            } else if var month = map[title] {
                month.entriesCount += 1
                if $0.type == .rock {
                    month.rockEntriesCount += 1
                }
                map[title] = month
            }
        }
        
        months = Array(map.values).sorted(by: { month1, month2 in
            month1 < month2
        })
    }
    
    func recordBinding() -> Binding<Record> {
        switch editorMode {
        case .add:
            return Binding {
                self.newRecord ?? Record()
            } set: {
                self.newRecord = $0
            }
        case .edit:
            return Binding {
                self.editedRecord ?? Record()
            } set: {
                self.editedRecord = $0
            }
        }
    }
}
