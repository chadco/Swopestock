//
//  PostCell.swift
//  swopestock-app
//
//  Created by Chad Comstock on 2/1/16.
//  Copyright © 2016 Chad Comstock. All rights reserved.
//

import UIKit
import Alamofire
import Firebase


class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!
    var request: Request?
    var likeRef: Firebase!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.userInteractionEnabled = true
    }

    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        showcaseImg.clipsToBounds = true
    }
    
    func configureCel(post: Post, img: UIImage?) {
        
        self.post = post
        likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        self.descriptionTxt.text = post.postDescription
        self.likesLbl.text = "\(post.likes)"
        
        if post.imageUrl != nil {
            
            
            if img != nil {
                
                self.showcaseImg.image = img
                
            } else {
                
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { (request, response , data, err) -> Void in
                    
                    if err == nil {
                        let img = UIImage(data: data!)!
                        self.showcaseImg.image = img
                        FeedVC.imageCache.setObject(img, forKey: self.post.imageUrl!)
                    } else {
                        
                        print(err.debugDescription)
                    }
                    
                    
                })
                
            }
            
            self.showcaseImg.hidden = false
            
        } else {
            
            self.showcaseImg.hidden = true
            
        }
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let _ = snapshot.value as? NSNull {
                
                // This means we have not liked specif post
                self.likeImg.image = UIImage(named: "ic_favorite_border_white_48pt")
                
            } else {
                
                self.likeImg.image = UIImage(named: "ic_favorite_48pt")
                
            }
            
        })
        
    }
    
    func likeTapped(sender: UIGestureRecognizer) {
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let _ = snapshot.value as? NSNull {
                
                // This means we have not liked specif post
                self.likeImg.image = UIImage(named: "ic_favorite_48pt")
                self.post.adjustLikes(true)
                self.likeRef.setValue(true)
                
            } else {
                
                self.likeImg.image = UIImage(named: "ic_favorite_border_white_48pt")
                self.post.adjustLikes(false)
                self.likeRef.removeValue()
                
            }
        })
        
    }

}
