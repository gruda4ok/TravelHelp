//
//  Users.swift
//  TravelHelp
//
//  Created by air on 05.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation
import Firebase

struct Users {
    
    let uid:String
    let email:String
    let name: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
        self.name = user.displayName!
    }
    
}


