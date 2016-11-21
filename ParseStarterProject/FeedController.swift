//
//  FeedController.swift
//  ParseStarterProject-Swift
//
//  Created by Atıl Samancıoğlu on 18/11/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import OneSignal

class FeedController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var postOwnerArray = [String]()
    var postCommentArray = [String]()
    var postImageArray = [PFFile]()
    var postUuidArray = [String]()
    
    var playerID = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        getPostsfromServer()
        
        OneSignal.idsAvailable { (userID, pushToken) in
            if userID != nil {
                self.playerID = userID!
            }
        }
     
        let user = PFUser.current()
        user?["playerID"] = self.playerID
        user?.saveEventually()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //receive local notification from UploadController to reload data!
        NotificationCenter.default.addObserver(self, selector: #selector(FeedController.newPicture(_:)), name: NSNotification.Name(rawValue: "newPicture" ), object: nil)
        
        
        
    }
    
    func newPicture ( _ notification: Notification) {
        getPostsfromServer()
        tableView.reloadData()
    }
    
    func getPostsfromServer () {
        
        let query = PFQuery(className: "posts")
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (objects, error) in
        
            if error != nil {
                let alert = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
            } else {
                
                //clean arrays up
                self.postImageArray.removeAll(keepingCapacity: false)
                self.postCommentArray.removeAll(keepingCapacity: false)
                self.postOwnerArray.removeAll(keepingCapacity: false)
                self.postUuidArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    
                    //add the objects into the arrays
                    self.postOwnerArray.append(object.object(forKey: "postowner") as! String)
                    self.postCommentArray.append(object.object(forKey: "postcomment") as! String)
                    self.postImageArray.append(object.object(forKey: "postimage") as! PFFile)
                    self.postUuidArray.append(object.object(forKey: "postuuid")as! String)
                }
            }
            
            self.tableView.reloadData()
        }
        

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postOwnerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! feedCell
        
        cell.postUuidLabel.isHidden = true
        cell.userNameLabel.text = postOwnerArray[indexPath.row]
        cell.commentLabel.text = postCommentArray[indexPath.row]
        cell.postUuidLabel.text = postUuidArray[indexPath.row]
        postImageArray[indexPath.row].getDataInBackground { (data, error) in
            if error != nil {
                let alert = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
            } else {
                cell.postImage.image = UIImage(data: data!)
            }
        }
        
        return cell
    }
 
    @IBAction func logOutButtonClicked(_ sender: Any) {
        
        PFUser.logOutInBackground { (error) in
            if error != nil {
                let alert = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
            } else {
                
                UserDefaults.standard.removeObject(forKey: "userinfo")
                UserDefaults.standard.synchronize()
                
                let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signIn") as! SignInController
                
                let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                delegate.window?.rootViewController = signIn
            }
        }
        
    }

}
