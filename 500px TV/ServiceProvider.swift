//
//  ServiceProvider.swift
//  500px TV
//
//  Created by Finn Gaida on 07.10.15.
//  Copyright © 2015 Finn Gaida. All rights reserved.
//

import Foundation
import TVServices

class ServiceProvider: NSObject, TVTopShelfProvider {

    override init() {
        super.init()
    }

    // MARK: - TVTopShelfProvider protocol
    
    var topShelfStyle: TVTopShelfContentStyle {
        // Return desired Top Shelf style.
        return TVTopShelfContentStyle.Sectioned
    }
    
    var topShelfItems: [TVContentItem] {
        // Create an array of TVContentItems.
        
        let items: [TVContentItem] = (0...4).map { (number) -> TVContentItem in
            
            let item = TVContentItem(contentIdentifier: TVContentIdentifier(identifier: "de.finngaida.500px.500px-TV.\(number)", container: nil)!)
            item?.imageShape = TVContentItemImageShape.Square
            
            if (NSFileManager.defaultManager().fileExistsAtPath("\(Network().cache())/\(number).jpg")) {
                item?.imageURL = NSURL.fileURLWithPath("\(Network().cache())/\(number).jpg")
            }
                
            item?.displayURL = NSURL(string: "500pxtv://shelf?id=\(number)")
//            item?.title = "image nr. \(number)"
            
            return item!
        }
        
        let master = TVContentItem(contentIdentifier: TVContentIdentifier(identifier: "de.finngaida.tvos-test.shelf", container: nil)!)
        master?.topShelfItems = items
        return (topShelfStyle == .Inset) ? items : [master!]
    }
    
}


