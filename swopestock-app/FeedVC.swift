//
//  FeedVC.swift
//  swopestock-app
//
//  Created by Chad Comstock on 2/1/16.
//  Copyright © 2016 Chad Comstock. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    static var imageCache = NSCache()
    @IBOutlet weak var postField: MaterialTextField!
    @IBOutlet weak var imageSelector: UIImageView!
    
    var imageSelected = false
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 448
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            
            self.posts = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    print("Snap: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                        
                    }
                }
                
                
                
            }
            
            self.tableView.reloadData()
            
        })
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            cell.request?.cancel()
            
            var img: UIImage?
            
            if let url = post.imageUrl {
                
                print(url)
                
                img = FeedVC.imageCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCel(post, img: img)
            
            
            return cell
            
        } else {
            
            return PostCell()
            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post = posts[indexPath.row]
        
        if post .imageUrl == nil {
            
            return 170
            
        } else  {
            return tableView.estimatedRowHeight
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelector.image = image
        imageSelected = true
        
    }
   
    @IBAction func makePost(sender: AnyObject) {
        
        if let txt = postField.text where txt != "" {
            
            
            if let img = imageSelector.image where imageSelected == true {
                
                activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
                activityIndicator.backgroundColor = UIColor(red: 32.0/255.0, green: 49.0/255.0, blue: 98.0/255.0, alpha: 0.5)
                
                
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                
                UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                
                let urlStr = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: urlStr)!
                
                let imageData = UIImageJPEGRepresentation(img, 0.3)!
                let keyData = "1BEHJKUY9406866332031c18f0c47e3d8b182144".dataUsingEncoding(NSUTF8StringEncoding)!
                
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                Alamofire.upload(.POST, url, multipartFormData: { multipartFormData  in
                    
                    multipartFormData.appendBodyPart(data: imageData, name: "fileupload", fileName: "image", mimeType: "images/jpg")
                    multipartFormData.appendBodyPart(data: keyData, name: "key")
                    multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                    
                    }) { encodingResult in
                        
                        switch encodingResult {
                        case .Success(let upload, _, _):
                            
                            upload.responseJSON(completionHandler: { (response) -> Void in
                            
                                if let info = response.result.value as? Dictionary<String, AnyObject> {
                                    
                                    if let links = info["links"] as? Dictionary<String, AnyObject> {
                                        
                                        if let imgLink = links["image_link"] as? String {
                                            
                                            self.postToFirebase(imgLink)
                                            
                                        }
                                        
                                    }
                                    
                                }
                            })
                            
                        case .Failure(let error):
                            print(error)
                        }
                        
                    
                        
                }
                    
            } else {
                
                self.postToFirebase(nil)
                
            }
            
        }
        
    }
    
    func postToFirebase(imgUrl: String?) {
        
        var post: Dictionary<String, AnyObject> = [
            
            "description": postField.text!,
            "likes": 0
            
        ]
        
        if imgUrl != nil {
            post["imageUrl"] = imgUrl!
        }
        
        let firePost = DataService.ds.REF_POSTS.childByAutoId()
        firePost.setValue(post, withCompletionBlock: { error, data in
            
            if error != nil {
                
                // Put in some type of error ALERT
                print(error.debugDescription)
                
            } else {
                self.postField.text = ""
                self.imageSelector.image = UIImage(named: "ic_add_a_photo_48pt")
                self.imageSelected = false
                self.tableView.reloadData()

            }
        })
        
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
}
