//
//  Network.swift
//  500px
//
//  Created by Finn Gaida on 06.10.15.
//  Copyright © 2015 Finn Gaida. All rights reserved.
//

import UIKit

class Network: NSObject {

    let baseURL = "https://api.500px.com/v1/photos"
    let consumerKey = "JVqJtmX9JAG262oWBDgkqcQGpRgKLDuBw0sgO21p"
    
    func getPhotos(feature: String, sort: String, imageSize: Int, pages: Int, response: ([AnyObject]) -> ()) {
        
        var final:Array<AnyObject> = []
        for page in 0...pages {
            
            let urlStr = "\(baseURL)?feature=\(feature)&sort=\(sort)&image_size=\(imageSize)&page=\(page)&consumer_key=\(consumerKey)"
                
                do {
                    let res = try NSData (contentsOfURL: NSURL(string: urlStr)!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                    let dict = try NSJSONSerialization.JSONObjectWithData(res, options: NSJSONReadingOptions.AllowFragments)
                    final += dict["photos"] as! Array<AnyObject>
                    
                } catch {
                    print("Error: \(error)")
                }
            
        }
        
        response(final)
        
    }
    
    func check(this: UIImage, number: Int) {
        
        let manager = NSFileManager.defaultManager()
        let file = "\(cache())/\(number).jpg"
        if (!manager.fileExistsAtPath(file)) {
            UIImageJPEGRepresentation(this, 1)?.writeToFile(file, atomically: true)
        }
        
    }
    
    func cache() -> String {
        let caches = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true) as [String]
        return caches[0]
    }
    
}
