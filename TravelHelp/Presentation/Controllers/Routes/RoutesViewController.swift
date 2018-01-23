//
//  RoutesViewController.swift
//  TravelHelp
//
//  Created by air on 10.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit

class RoutesViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var routesTableView: UITableView!
    fileprivate var routesArray: Array<RouteBase> = []
    private var filterData = [RouteBase]()
    private var isSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupNotification()
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        searchBar.keyboardAppearance = .dark
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DatabaseService.shared.snapshotRoutes { [weak self] routes in
            self?.reloadTableView(routes: routes)
        }
    }
    
    func setupInterface() {
        routesTableView.tableFooterView = UIView()
        routesTableView.register(UINib(nibName: String(describing: RoutesTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: RoutesTableViewCell.self))
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc func keyBoardDidShow(notification: Notification){
        if let view = view as? UIScrollView {
            view.setContentOffset(CGPoint(x:0,y:0), animated: true)
        }
    }
    
    @objc func keyBoardDidHide() {
        if let view = view as? UIScrollView {
            view.setContentOffset(CGPoint(x:0,y:0), animated: true)
        }
    }
}

extension RoutesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearchMode = false
            view.endEditing(true)
            routesTableView.reloadData()
        } else {
            isSearchMode = true
            filterData = routesArray.filter({$0.routeID == searchBar.text})
            routesTableView.reloadData()
        }
    }
    @objc func dissmisText() {
        searchBar.endEditing(true)
    }
}

extension RoutesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
}

extension RoutesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchMode{
            return filterData.count
        }
        return routesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RoutesTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: RoutesTableViewCell.self), for: indexPath) as! RoutesTableViewCell
        if isSearchMode{
            cell.configurate(route: filterData[indexPath.row])
        }else{
            cell.configurate(route: routesArray[indexPath.row])
        }
        return cell
    }
    
    func reloadTableView(routes: Array<RouteBase>) {
        self.routesArray = routes
        routesTableView.reloadData()
    }
}
