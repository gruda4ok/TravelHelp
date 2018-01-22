//
//  RoutesViewController.swift
//  TravelHelp
//
//  Created by air on 10.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit

class RoutesViewController: UIViewController {

    @IBOutlet private weak var routesTableView: UITableView!
    fileprivate var routesArray: Array<RouteBase> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DatabaseService.shared.snapshotRoutes { [weak self] routes in
            self?.reloadTableView(routes: routes)
        }
    }
    
    func setupInterface(){
        routesTableView.tableFooterView = UIView()
        routesTableView.register(UINib(nibName: String(describing: RoutesTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: RoutesTableViewCell.self))
    }
}

extension RoutesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
}

extension RoutesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RoutesTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: RoutesTableViewCell.self), for: indexPath) as! RoutesTableViewCell
        cell.configurate(route: routesArray[indexPath.row])
        return cell
    }
    func reloadTableView(routes: Array<RouteBase>) {
        self.routesArray = routes
        routesTableView.reloadData()
    }
}
