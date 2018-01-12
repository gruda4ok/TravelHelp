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
   
    func saveUser(uid:String, email: String, name: String){
        let ref = Database.database().reference(withPath: "users")
        let userRef = ref.child(uid)
        userRef.setValue(["email": email])
        userRef.setValue(["Name": name])
    }
    
    func snapshot(user: UserModel?) {
        guard let user = user else {return}
        let ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("travel")
        ref.observe(.value) {(snapshot) in
            var travel = Array<TravelBase>()
            for item in snapshot.children{
                let traveld = TravelBase(snapshot: item as! DataSnapshot)
                travel.append(traveld)
            }
        }
    }
    
    func addTravel(name: String?, user: UserModel?, date: String?){
        
        guard
            let user = user,
            let name = name,
            let date = date
        else {
            return
        }
    
        let ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("travel")
        let travel = TravelBase(travelId: name, userId: user.uid, date: date)
        let tickedRef = ref.child((travel.travelId?.lowercased())!)
        tickedRef.setValue(travel.convertToDictionary())
    }
}
