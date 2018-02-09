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
    let travelId: String
    let userId: String
    let dateStart: String
    let endDate: String
    let discription: String
    
    init( travelId: String, userId: String, dateStart: String, endDate: String, discription: String) {
        self.travelId = travelId
        self.userId = userId
        self.dateStart = dateStart
        self.endDate = endDate
        self.discription = discription
    }

    init?(snapshot: DataSnapshot) {
        guard
            let snapshotValue = snapshot.value as? [String: String],
            let travelId = snapshotValue["travelId"]
        else{
            return nil
        }
        self.travelId = travelId
        userId = snapshotValue["userId"] ?? ""
        dateStart = snapshotValue["dateStart"] ?? ""
        endDate = snapshotValue["endDate"] ?? ""
        discription = snapshotValue["discription"] ?? ""
    }
    
    func convertToDictionary() -> Any {
        return ["travelId":travelId,
                "userId": userId,
                "dateStart": dateStart,
                "endDate": endDate,
                "discription": discription,]
    }
}
