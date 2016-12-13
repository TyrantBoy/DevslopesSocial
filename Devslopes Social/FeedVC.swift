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
    @IBOutlet weak var addImage: CircleView!
    @IBOutlet weak var captionField: FancyTextField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

        //updates likes and feed
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            //instant change, if you edit data in data base
           // print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? [String: AnyObject] {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            
            self.myTable.reloadData()
        })
    }

  
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func signOutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("DONALD: ID is removed \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "signout", sender: nil)
    }
    
    @IBAction func post(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print("DONALD: caption must be entered")
            return
        }
        
        guard let img = addImage.image, imageSelected == true else {
            print("DONALD: An image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUID = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            //Storage data base
            DataService.ds.REF_POST_IMAGES.child(imgUID).put(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("DONALD: Unable to upload image to firebase storage")
                } else {
                    print("DONALD: Successfully uploaded image to firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    
                    //POST IT
                    if let url = downloadURL {
                        self.postToFirebase(imgURL: url)
                    }
                }
            }
        }
    }
    
    func postToFirebase(imgURL: String) {
        let post: [String: AnyObject] = [
            "caption": captionField.text as AnyObject,
            "imageUrl": imgURL as AnyObject,
            "likes": 0 as AnyObject
        ]
        
        //auto-generate post key
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        addImage.image = UIImage(named: "Compact Camera")
        
        
       // myTable.reloadData()
    }
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as? PostCell {
            
            if let img  = FeedVC.imageCache.object(forKey: post.imageURL as NSString) {
                cell.updateCell(post: post, img: img)
                return cell
            } else {
                cell.updateCell(post: post)
                return cell
            }
     
        } else {
            return PostCell()
        }
    }
}

extension FeedVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image  = image
            imageSelected = true
            
        } else {
            print("Donald: A valid image wasn't selected") 
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
