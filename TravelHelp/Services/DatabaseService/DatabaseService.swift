//
//  DatabaseService.swift
//  TravelHelp
//
//  Created by air on 11.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation
import Firebase

typealias TravelsSnapshotClosureType = (_ travels: Array<TravelBase>) -> Void

class DatabaseService {
    
    static let shared = DatabaseService()
   
    func saveUser(uid:String, email: String, name: String){
        let ref = Database.database().reference(withPath: "users")
        let userRef = ref.child(uid)
        userRef.setValue(["email": email])
        let nameRef = ref.child(uid).child("Name")
        nameRef.setValue(name)
    }
    
    func snapshot(user: UserModel?, complition: @escaping TravelsSnapshotClosureType){
        guard let user = user else {return}
        let ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("travel")
        ref.observe(.value) {(snapshot) in
            let travels = snapshot.children.flatMap{
                return TravelBase(snapshot: $0 as! DataSnapshot)
            }
            complition(travels)
        }
    }
    
    func addTravel(name: String?, user: UserModel?, dateStart: String?, endDate: String?, discription: String?){
        
        guard
            let user = user,
            let name = name,
            let dateStart = dateStart,
            let endDate = endDate,
            let discription = discription
        else {
            return
        }
        
        let ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("travel")
        let travel = TravelBase(travelId: name, userId: user.uid, dateStart: dateStart, endDate: endDate, discription: discription)
        let tickedRef = ref.child(travel.travelId.lowercased())
        tickedRef.setValue(travel.convertToDictionary())
    }
}
