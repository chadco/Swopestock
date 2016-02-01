//
//  ViewController.swift
//  swopestock-app
//
//  Created by Chad Comstock on 1/31/16.
//  Copyright © 2016 Chad Comstock. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
        
    }

    @IBAction func fbBynPressed(sender: UIButton!) {
        
        //let ref = Firebase(url: "https://swopestock.firebaseio.com")
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"], handler: { (facebookResult, facebookError) in
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Succesfull login to facebook. \(accessToken)")
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { (error , authData) -> Void in
                    
                    if error != nil {
                        print("login falied. \(error)")
                    } else {
                        
                        print("You logged in. \(authData)")
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                        
                    }
                    
                })
                /*ref.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        
                        if error != nil {
                            println("Login failed. \(error)")
                        } else {
                            println("Logged in! \(authData)")
                        }
                })
                */
            }
        })
        
    }

    @IBAction func emailLoginPressed(sender: AnyObject) {
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
        
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                
                if error != nil {
                    print(error)
                    
                    if error.code == STATUS_ACCOUNT_NOEXIST {
                        
                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
                            
                            if error != nil {
                                
                                self.showErrorAlert("Could not creat account", msg: "Problem creating account.  Please try again.")
                                
                            } else {
                                
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                
                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: nil)
                                
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                                
                            }
                            
                        })
                        
                    } else if error.code == STATUS_WRONG_PASSWORD {
                        
                        self.showErrorAlert("Could not log in", msg: "Your specified password is incorrect.")
                        
                    } else if error.code == STATUS_INVALID_EMAIL {
                        
                        self.showErrorAlert("Could not log in", msg: "The email address is invalid")
                    }
                    
                } else {
                    
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    
                }
                
            })
        
        } else {
        
        showErrorAlert("Email and password required", msg: "You must enter email and password.")
        }
    }
 
    
    func showErrorAlert(title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
    }
}

