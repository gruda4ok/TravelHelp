//
//  RouteBase.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 22.01.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation
import Firebase

struct RouteBase {
    let routeID: String
    let userID: String
    
    init(routeID: String, userID: String)  {
        self.routeID = routeID
        self.userID = userID
    }
    init?(snapshot: DataSnapshot){
        guard
            let snapshotValue = snapshot.value as? [String: String],
            let routeID = snapshotValue["routeID"]
        else{
            return nil
        }
        self.routeID = routeID
        userID = snapshotValue["userID"] ?? ""
    }
    
    func convertToDictionary() -> Any {
        return ["routeID":routeID, "userID": userID]
    }
}
