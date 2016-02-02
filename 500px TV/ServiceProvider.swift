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
        
        if let max = NSUserDefaults(suiteName: "group.finngaida.photoviewer")?.integerForKey("highest") {
            let items: [TVContentItem] = (0...max).map { (number) -> TVContentItem in
                
                let item = TVContentItem(contentIdentifier: TVContentIdentifier(identifier: "de.finngaida.500px.500px-TV.\(number)", container: nil)!)
                item?.imageShape = TVContentItemImageShape.Square
                
                let url = NSUserDefaults(suiteName: "group.finngaida.photoviewer")?.stringForKey("\(number)")!
                item?.imageURL = NSURL(string: url ?? "")!
                
                let urlString = url! as NSString
                let start = ("https://api.500px.com/v1/photos").characters.count
                let photoID = urlString.substringWithRange(NSMakeRange(start, urlString.length - start - 1))
                print(photoID)
                
                item?.displayURL = NSURL(string: "fivehundredpxtv://" + photoID)
                item?.playURL = NSURL(string: "fivehundredpxtv://" + photoID)
                //                item?.title = "image nr. \(number)"
                
                return item!
            }
            
            let master = TVContentItem(contentIdentifier: TVContentIdentifier(identifier: "de.finngaida.tvos-test.shelf", container: nil)!)
            master?.topShelfItems = items
            return (topShelfStyle == .Inset) ? items : [master!]
        } else {
            return []
        }
    }
    
}


