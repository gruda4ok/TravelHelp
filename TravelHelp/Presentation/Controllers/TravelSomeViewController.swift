//
//  ViewController.swift
//  TravelHelp
//
//  Created by air on 12.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit

class TravelSomeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    var travel: TravelBase?
    var nameTravel: String? = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    func setupInterface(){
        if let travel = travel{
            nameLabel.text = travel.travelId
        }else{
            print("Error")
        }
    }
}
