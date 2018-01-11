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
    var user: UserModel? = AutorizationService.shared.localUser
    var ref: DatabaseReference! = Database.database().reference().child("users")
    var travelId: String?
    var travelTitle: String = "1"
    
    let queue = DispatchQueue(label: "queue", qos: .userInitiated, attributes: .concurrent)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        createNewTravel.layer.cornerRadius = createNewTravel.frame.height / 2
        
//        guard let currentUser = Auth.auth().currentUser else { return }
//
//        user = UserModel(user: currentUser)
//        ref = Database.database().reference(withPath: "users").child(String(describing: user?.uid)).child("tickets")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let user = user else {return}

            travelId = String(arc4random_uniform(100)) + user.uid
            DatabaseService.shared.snapshot()
            tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
       // let travelTitle = travel[indexPath.row].travelId
        cell.textLabel?.text = travelTitle
        return cell
    }
    
    @IBAction func createNewTravel(_ sender: AnimationButton) {
        //performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
