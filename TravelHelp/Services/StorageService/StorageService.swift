//
//  StoregService.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 16.01.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation
import Firebase

class StorageService {
    static let shared = StorageService()
    
    func saveImage(image: Image, name: String) {
        if let data = image.data{
            let storageRef = Storage.storage().reference().child("Avatar").child(name)
            let metadata = StorageMetadata()
            metadata.contentType = image.contentType
            let uploadTask = storageRef.putData(data, metadata: metadata) { (metadata, error) in

            }
            uploadTask.resume()
        }
    }
}
