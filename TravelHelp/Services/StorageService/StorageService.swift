//
//  StoregService.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 16.01.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation
import Firebase

typealias DownloadImageURLClosure = (_ url: URL?) -> Void

class StorageService {
    static let shared = StorageService()
    var user: UserModel? = AutorizationService.shared.localUser
    func saveImage(image: Image, name: String) {
        if let data = image.data{
            let storageRef = Storage.storage().reference().child("Avatar").child(name)
            let metadata = StorageMetadata()
            metadata.contentType = image.contentType
            let uploadTask = storageRef.putData(data, metadata: metadata) { (metadata, error) in
            }
            uploadTask.resume()
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print("URl don't create")
                }else{
                    print(url ?? String.self)
                }
            })
        }
    }
    
    func saveImageTravel(image: Image, user: UserModel?, travel: TravelBase?) {
        guard
            let user = user,
            let travel = travel
        else {
            return
        }
        if let data = image.data{
            let storageRef = Storage.storage().reference().child("ImageTravel").child(user.uid).child(travel.travelId)
            let metadata = StorageMetadata()
            metadata.contentType = image.contentType
            let uploadTask = storageRef.putData(data, metadata: metadata) { (metadata, error) in
            }
            uploadTask.resume()
           
        }
    }
    func travelImage(user: UserModel?, travel: TravelBase?, completion: @escaping DownloadImageURLClosure){
        guard
            let user = user,
            let travel = travel
        else {
            return
        }
        let storageRef = Storage.storage().reference().child("ImageTravel").child(user.uid).child(travel.travelId)
        storageRef.downloadURL(completion: { (url, error) in
            completion(url)
        })
    }
}
