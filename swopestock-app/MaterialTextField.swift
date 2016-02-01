//
//  MaterialTextField.swift
//  swopestock-app
//
//  Created by Chad Comstock on 1/31/16.
//  Copyright © 2016 Chad Comstock. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    override func awakeFromNib() {
        
        layer.cornerRadius = 3.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.125).CGColor
        
        layer.borderWidth = 1.0
        
        
    }
    
    // For placeholder
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        
        return CGRectInset(bounds, 10, 0)
        
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        
        return CGRectInset(bounds, 10, 0)
    }
}
