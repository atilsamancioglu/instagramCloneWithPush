//
//  feedCell.swift
//  ParseStarterProject-Swift
//
//  Created by Atıl Samancıoğlu on 19/11/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import OneSignal

class feedCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var postUuidLabel: UILabel!
    
    var playerIDArray = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func commentButtonClicked(_ sender: Any) {
        
        let commentObject = PFObject(className: "comments")
        commentObject["from"] = PFUser.current()!.username!
        commentObject["to"] = postUuidLabel.text
        commentObject.saveInBackground { (success, error) in
            if error != nil {
            print(error)
            } else {
                
                let query = PFQuery(className: "_User")
                query.whereKey("username", equalTo: self.userNameLabel!.text!)
                query.findObjectsInBackground(block: { (objects, error) in
                    if error != nil {
                        print(error)
                    } else {
                        
                        self.playerIDArray.removeAll(keepingCapacity: false)
                        for object in objects! {
                            self.playerIDArray.append(object.object(forKey: "playerID") as! String)
                            
                             OneSignal.postNotification(["contents" : ["en" : "\(PFUser.current()!.username!) has commented on your post"], "include_player_ids" : ["\(self.playerIDArray.last!)"]])
                            
                        }
                    }
                })
                
               
            }
        }
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        
        let likeObject = PFObject(className: "likes")
        likeObject["from"] = PFUser.current()!.username!
        likeObject["to"] = postUuidLabel.text
        
        likeObject.saveInBackground { (success, error) in
            if error != nil {
              print(error)
            } else {
                
                let query = PFQuery(className: "_User")
                query.whereKey("username", equalTo: self.userNameLabel!.text!)
                query.findObjectsInBackground(block: { (objects, error) in
                    if error != nil {
                        print(error)
                    } else {
                        
                        self.playerIDArray.removeAll(keepingCapacity: false)
                        for object in objects! {
                            self.playerIDArray.append(object.object(forKey: "playerID") as! String)
                            
                            OneSignal.postNotification(["contents" : ["en" : "\(PFUser.current()!.username!) has liked your post"], "include_player_ids" : ["\(self.playerIDArray.last!)"]])
                            
                        }
                    }
                })
                
                
            }
        }
    }
    
}
