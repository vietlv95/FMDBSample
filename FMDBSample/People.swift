//
//  People.swift
//  FMDBSample
//
//  Created by Viet Le on 08/08/2021.
//

import UIKit
import FMDB

class People {
    var peopleID = ""
    var name = ""
    var phone = ""
    
    init() {
        
    }
    
    init(resultSet: FMResultSet) {
        self.peopleID = resultSet.string(forColumn: "PeopleID") ?? ""
        self.name = resultSet.string(forColumn: "Name") ?? ""
        self.phone = resultSet.string(forColumn: "Phone") ?? ""
    }
    
    func insertToDB() {
        let query = "insert into People (PeopleID, Name, Phone) values ('\(peopleID)', '\(name)', '\(phone)')"
        _ = DBController.shared.excuteUpdate(query: query)
    }
    
    func delete() {
        let query = "delete from People where peopleID = \(self.peopleID)"
        _ = DBController.shared.excuteUpdate(query: query)
    }
    
    func saveUpdate() {
        let query = "update People set Name = \(self.name), Phone = \(self.phone) where peopleID = \(self.peopleID)"
        _ = DBController.shared.excuteUpdate(query: query)
    }
}
