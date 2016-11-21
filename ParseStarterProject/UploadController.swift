//
//  UploadController.swift
//  ParseStarterProject-Swift
//
//  Created by Atıl Samancıoğlu on 18/11/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UploadController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var uploadBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        
        //hide keyboard function
        let hideKeyboard = UITapGestureRecognizer(target: self, action: #selector(UploadController.hideKeyBoard))
        hideKeyboard.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(hideKeyboard)
        
        
        //image tap for enabling user to choose one image from their phone
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(UploadController.selectImage))
        imageTap.numberOfTapsRequired = 1
        postImage.isUserInteractionEnabled = true
        postImage.addGestureRecognizer(imageTap)
        
        uploadBtn.isEnabled = false
        
    }
    
    func hideKeyBoard(){
        self.view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
   

    func selectImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        postImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        uploadBtn.isEnabled = true
    }
    
    
    @IBAction func uploadBtnClicked(_ sender: Any) {
        
        uploadBtn.isEnabled = false
        
        let object = PFObject(className: "posts")
        
        let data = UIImageJPEGRepresentation(postImage.image!, 0.5)
        let pfImage = PFFile(name: "image.jpg", data: data!)
        object["postimage"] = pfImage
        
        object["postowner"] = PFUser.current()!.username!
        
        let uuid = UUID().uuidString
        
        object["postuuid"] = "\(uuid) \(PFUser.current()!.username!)"
        
        object["postcomment"] = textField.text
        
        object.saveInBackground { (success, error) in
            if error != nil {
                let alert = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
            } else {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newPicture"), object: nil)
                
                self.textField.text = ""
                self.postImage.image = UIImage(named: "background.png")
                self.tabBarController?.selectedIndex = 0

            }
        }
    
    }
   

}
