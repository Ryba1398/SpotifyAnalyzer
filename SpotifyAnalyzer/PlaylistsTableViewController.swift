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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("----------------------------------------------------------------")
        
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        self.tableView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: "playlistCell")
        self.view.backgroundColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
                
        if playlistStore.items.count == 0 {
          print("Loading podcast feed for the first time")
          playlistStore.refreshItems{ didLoadNewItems in
            if (didLoadNewItems) {
              DispatchQueue.main.async {
                
                print("update")
                
                self.tableView.reloadData()
              }
            }
            else{
                print("NO")
            }
          }
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath) as! PlaylistTableViewCell
        
        
        cell.initCell(playlist: playlistStore.items[indexPath.row])
        
        return cell
    }
}