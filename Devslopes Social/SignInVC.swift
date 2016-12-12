//
//  ViewController.swift
//  Devslopes Social
//
//  Created by Donald Nguyen on 12/10/16.
//  Copyright © 2016 Donald Nguyen. All rights reserved.
//

//material.google.com
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase


/**
 Enable FB login in Firebase AUTH Sign-In Tab
 Add in FB App ID & Secret from the FB dashboard
 Copy & pasta the link to Facebook Login (Under PRODUCTS) > Settings > In "Valid OAuth redirect URLs
 **/

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func FBTapped(_ sender: UIButton) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"] , from: self) { (result, error) in
            if error != nil {
                print("DONALD: Uable to authorize with FB \(error)")
            } else if result?.isCancelled == true {
                print("DONALD: User cancelled")
            } else {
                
                //if facebook login is ok -> 
                print("DONALD: Successfully authenticated with FB")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("DONALD: Unable to authenticate with Firebase - \(error)")
            } else {
                print("DONALD Successfully authenticated with Firebase")
            }
        })
    }


}

