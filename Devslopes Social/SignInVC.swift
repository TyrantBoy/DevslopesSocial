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
import SwiftKeychainWrapper


/**
 Enable FB login in Firebase AUTH Sign-In Tab
 Add in FB App ID & Secret from the FB dashboard
 Copy & pasta the link to Facebook Login (Under PRODUCTS) > Settings > In "Valid OAuth redirect URLs
 
 
 Keychain WILL ALWAYS keep users data even if they destroyed the app :O!!!!
 
 **/


class SignInVC: UIViewController {
    @IBOutlet weak var emailField: FancyTextField!
    
    //attribute inspector > secure text
    @IBOutlet weak var passwordField: FancyTextField!
    
    
    //cannot perform segue too early
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "feed", sender: nil)
        }
        
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
                
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        })
    }


    @IBAction func signInTapped(_ sender: UIButton) {
        if let email = emailField.text, let pwd = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                        print("DONALD: User authenticated with Firebase")
                    
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                    
                } else {
                    //doesn't exist, create
                    //6+ characters for password
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("DONALD: Unable to authenticate with Firebase using email ")
                        } else {
                            print("DONALD: Succesfully authentiated with Firebase")
                            
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                    
                }
            })
        }
    }
    
    func completeSignIn(id: String) {
        let keychainResult =  KeychainWrapper.standard.set(id, forKey: KEY_UID)
          print("DONALD: Data saved to keychain \(keychainResult)")
        
        //it works!
        performSegue(withIdentifier: "feed", sender: nil)
    }

}

