//
//  TravelViewController.swift
//  TravelHelp
//
//  Created by air on 10.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit
import Firebase

class TravelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createNewTravel: AnimationButton!
    
    var travel: Array<TravelBase> = []
    var user: Users!
    var ref: DatabaseReference!
    var travelId: String?
    var travelTitle: String = "1"
    
    let queue = DispatchQueue(label: "queue", qos: .userInitiated, attributes: .concurrent)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        createNewTravel.layer.cornerRadius = createNewTravel.frame.height / 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queue.async(flags: .barrier) {
            self.travelId = String(arc4random_uniform(100)) + (self.user?.uid)!
            self.ref.observe(.value) { [weak self](snapshot) in
                var _travel = Array<TravelBase>()
                for item in snapshot.children{
                    let traveld = TravelBase(snapshot: item as! DataSnapshot)
                    _travel.append(traveld)
                }
                self?.travel = _travel
                self?.tableView.reloadData()
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let travelTitle = travel[indexPath.row].travelId
        cell.textLabel?.text = travelTitle
        return cell
    }
    
    @IBAction func createNewTravel(_ sender: AnimationButton) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
