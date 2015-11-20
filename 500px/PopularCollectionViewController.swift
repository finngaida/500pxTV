//
//  PopularCollectionViewController.swift
//  500px
//
//  Created by Finn Gaida on 06.10.15.
//  Copyright © 2015 Finn Gaida. All rights reserved.
//

import UIKit

class PopularCollectionViewController: BaseCollectionViewController {
    
    override func viewDidLoad() {
        self.feature = "popular"
        
        super.viewDidLoad()
    
    }
    
    override func delegateCall(sender: NSNotification) {
        super.delegateCall(sender)
    }
    
}
