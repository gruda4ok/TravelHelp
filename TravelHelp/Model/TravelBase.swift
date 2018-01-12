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
    let dateStart: String?
    let endDate: String?
    let discription: String?
    var ref: DatabaseReference!
    
    init( travelId: String, userId: String, dateStart: String, endDate: String, discription: String) {
        self.travelId = travelId
        self.userId = userId
        self.dateStart = dateStart
        self.endDate = endDate
        self.discription = discription
        self.ref = nil
    }

    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: String]
        travelId = snapshotValue["travel"]
        userId = snapshotValue["userId"]
        dateStart = snapshotValue["dateStart"]
        endDate = snapshotValue["endDate"]
        discription = snapshotValue["discription"]
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["travelId":travelId,
                "userId": userId,
                "dateStart": dateStart,
                "endDaew": endDate,
                "discription": discription ]
    }
}
