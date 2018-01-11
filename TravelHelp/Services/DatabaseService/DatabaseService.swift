//
//  DatabaseService.swift
//  TravelHelp
//
//  Created by air on 11.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation
import Firebase

class DatabaseService {
    
    static let shared = DatabaseService()
   
    func saveUser(uid:String, email: String){
        let ref = Database.database().reference(withPath: "users")
        let userRef = ref.child(uid)
        userRef.setValue(["email": email])
    }
    
    func snapshot() {
        let ref = Database.database().reference().child("users")
        ref.observe(.value) {(snapshot) in
            var travel = Array<TravelBase>()
            for item in snapshot.children{
                let traveld = TravelBase(snapshot: item as! DataSnapshot)
                travel.append(traveld)
            }
        }
    }
}
