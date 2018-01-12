//
//  TravelTableViewCell.swift
//  TravelHelp
//
//  Created by air on 12.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit

class TravelTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var dateStartLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    func configurate(travel: TravelBase){
        titleLabel.text = travel.travelId
        discriptionLabel.text = travel.discription
        dateStartLabel.text = travel.dateStart
        endDateLabel.text = travel.endDate
    }
}
