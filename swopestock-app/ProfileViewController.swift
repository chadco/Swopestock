//
//  ProfileViewController.swift
//  swopestock-app
//
//  Created by Chad Comstock on 2/2/16.
//  Copyright © 2016 Chad Comstock. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var username: MaterialTextField!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var imageSelector: UIButton!
    @IBOutlet weak var viewPosts: MaterialButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        profileImg.image = image
        
    }
    
    @IBAction func profilePicPressed(sender: AnyObject) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
        
    }

    @IBAction func viewPostsPressed(sender: AnyObject) {
        
        self.performSegueWithIdentifier(SEGUE_GOTO_FEED, sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
