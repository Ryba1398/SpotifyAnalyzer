//
//  PlaylistsTableViewController.swift
//  SpotifyAnalyzer
//
//  Created by Николай Рыбин on 12.09.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit

class PlaylistsTableViewController: UITableViewController {
    
    let playlistStore = PlaylistStore.sharedStore
    let defaultBackgroungColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LOAD VC")

        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutUser))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        configureTableViewController()
        configureRefreshControl()
        getTableItems()

    }
    
    @objc func logoutUser(){
        
        CurrentSessionManager.LogOut()
        navigationController?.popViewController(animated: true)
        
         print("clicked")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return playlistStore.items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension// 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath) as! PlaylistTableViewCell
        cell.initCell(playlist: playlistStore.items[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        adjustTransition()
        
        let pvc = PlaylistInfoViewController()
        pvc.setPlaylistInfo(playlist: self.playlistStore.items[indexPath.row])
        pvc.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(pvc, animated: false)
            
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: - Configure methods
    
    private func configureTableViewController(){
        navigationController?.navigationBar.barTintColor = defaultBackgroungColor

        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: "playlistCell")
        self.view.backgroundColor = defaultBackgroungColor
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    private func configureRefreshControl () {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.overrideUserInterfaceStyle = .dark
        self.refreshControl?.backgroundColor = defaultBackgroungColor
        self.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    // MARK: - Main methods
    
    private func getTableItems(){
        playlistStore.refreshItems{
            DispatchQueue.main.async {
                 self.tableView.reloadData()
             }
        }
    }
    
    private func adjustTransition(){
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
    }
    
    @objc func handleRefreshControl() {
        getTableItems()
        self.refreshControl?.endRefreshing()
    }
    
    
}
