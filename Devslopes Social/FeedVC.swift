//
//  FeedVC.swift
//  Devslopes Social
//
//  Created by Donald Nguyen on 12/11/16.
//  Copyright © 2016 Donald Nguyen. All rights reserved.
//

/**
 1. Sign out of fire base
 2. Remove keychain
 **/
import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    @IBOutlet weak var myTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

  

    @IBAction func signOutTapped(_ sender: UIButton) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("DONALD: ID is removed \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "signout", sender: nil)
    }
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "post") as! PostCell
    }
}
