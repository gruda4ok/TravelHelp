//
//  MenuViewController.swift
//  TravelHelp
//
//  Created by air on 18.12.2017.
//  Copyright © 2017 dogDeveloper. All rights reserved.
//

import UIKit
import AccountKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var accoutnKit: AKFAccountKit!
    let menuArray: Array<String> = ["Travel", "routes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

       tableView.tableFooterView = UIView()
        
        if accoutnKit == nil{
            self.accoutnKit = AKFAccountKit(responseType: .accessToken)
        }
            
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = menuArray[indexPath.row]
        
        return  cell
    }
    
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        accoutnKit.logOut()
        dismiss(animated: true, completion: nil)
    }

}
