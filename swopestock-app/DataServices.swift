//
//  DataServices.swift
//  swopestock-app
//
//  Created by Chad Comstock on 1/31/16.
//  Copyright © 2016 Chad Comstock. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "https://swopestock.firebaseio.com")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
}