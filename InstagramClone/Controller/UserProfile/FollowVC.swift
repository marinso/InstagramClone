//
//  FollowVC.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 01/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FollowCell"

class FollowVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FollowCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FollowCell
        
        return cell
    }
    
}
