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
    //let travelId: String
    //let userId: String
    let ref: DatabaseReference!
    
    init( userId: String) {
       // self.travelId = travelId
        //self.userId = userId
        self.ref = nil
        
    }

    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        //travelId = snapshotValue["travel"] as! String
        //userId = snapshotValue["userId"] as! String
        ref = snapshot.ref
    }
    
//    func convertToDictionary() -> Any {
//        return [,"userId": userId]
//    }
    
}
