//
//  CreateNewTravelViewController.swift
//  TravelHelp
//
//  Created by air on 12.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit

class CreateNewTravelViewController: UIViewController {

    var user: UserModel? = AutorizationService.shared.localUser
    
    @IBOutlet weak var create: AnimationButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        create.layer.cornerRadius = create.frame.height / 2
    }
    
    @IBAction func create(_ sender: AnimationButton) {
        DatabaseService.shared.addTravel(name: "Berlin", user: user, date: "1313")
        dismiss(animated: true, completion: nil)
    }
}
