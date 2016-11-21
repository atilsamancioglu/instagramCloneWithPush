//
//  SignInController.swift
//  
//
//  Created by Atıl Samancıoğlu on 19/11/2016.
//
//

import UIKit
import Parse
import OneSignal

class SignInController: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //hide keyboard function
        let hideKeyboard = UITapGestureRecognizer(target: self, action: #selector(SignInController.hideKeyBoard))
        hideKeyboard.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(hideKeyboard)
        
        
       
    }

    func hideKeyBoard(){
        self.view.endEditing(true)
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
    
        PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!) { (success,error) -> Void in
            if error != nil {
                let alert = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
            } else {
                
                UserDefaults.standard.set(success!.username!, forKey: "userinfo")
                UserDefaults.standard.synchronize()
                
                let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                
                delegate.rememberLogin()
                
            }
        
        }
        
    }

    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        let user = PFUser()
        user.username = usernameText.text
        user.password = passwordText.text
     
        
        user.signUpInBackground { (success, error) in
            if error != nil {
                let alert = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
            } else {
                UserDefaults.standard.set(user.username!, forKey: "userinfo")
                UserDefaults.standard.synchronize()
                
                let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                
                delegate.rememberLogin()
                
            }
        }
        
    }
}
