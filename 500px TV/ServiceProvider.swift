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
        
        if let max = NSUserDefaults(suiteName: "group.finngaida.500pxtv")?.integerForKey("highest") {
            let items: [TVContentItem] = (0...max).map { (number) -> TVContentItem in
                
                let item = TVContentItem(contentIdentifier: TVContentIdentifier(identifier: "de.finngaida.500px.500px-TV.\(number)", container: nil)!)
                item?.imageShape = TVContentItemImageShape.Square
                item?.imageURL = NSURL(string: (NSUserDefaults(suiteName: "group.finngaida.500pxtv")?.stringForKey("\(number)"))!)
                
                item?.displayURL = NSURL(string: "fivehundredpxtv://\(number)")
                item?.playURL = NSURL(string: "fivehundredpxtv://\(number)")
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


