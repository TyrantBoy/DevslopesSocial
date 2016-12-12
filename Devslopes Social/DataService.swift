//
//  DataService.swift
//  Devslopes Social
//
//  Created by Donald Nguyen on 12/12/16.
//  Copyright © 2016 Donald Nguyen. All rights reserved.
//

import Foundation
import Firebase


//URL of the root of our base
let DB_BASE = FIRDatabase.database().reference()

/**
 - Access Firebase database through URL at the highest point
 - make this class into a singleton
 **/
class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    //differentiate the database vs auth user
    func createFirebaseDBUser(uid: String, userData: [String : String]) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
