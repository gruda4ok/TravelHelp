//
//  File.swift
//  TravelHelp
//
//  Created by air on 11.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation

import Firebase

struct TravelBase {
    let travelId: String?
    let userId: String?
    let date: String?
    var ref: DatabaseReference!
    
    init( travelId: String, userId: String, date: String) {
        self.travelId = travelId
        self.userId = userId
        self.date = date
        self.ref = nil
    }

    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: String]
        travelId = snapshotValue["travel"]
        userId = snapshotValue["userId"]
        date = snapshotValue["date"]
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["travelId":travelId, "userId": userId, "date": date]
    }
}
