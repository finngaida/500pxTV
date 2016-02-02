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
        
        // clean array
        for (index, p) in final.enumerate() {
            if let nsfw = p["nsfw"] as? Int {
                if (nsfw == 1) {
                    final.removeAtIndex(index)
                }
            }
        }
        
        response(final)
        
    }
    
    enum Error:ErrorType {
        case SomeError
    }
    
    func getPhotoFromID(id: String) throws -> UIImage {
        
        let url = "https://api.500px.com/v1/photos/\(id)?image_size=4&consumer_key=MFi9GRap6ormQLI5zMRvgrU7eWL5QR6JizxiKetP"
        print("URL: \(url)")
        
        do {
            let data = try NSData(contentsOfURL: NSURL(string: url)!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            print("JSON: \(json)")
            
            guard let photo = json["photo"] else {throw Error.SomeError}
            guard let imgUrl = photo!["image_url"] as? String else {throw Error.SomeError}
            let imgData = try NSData(contentsOfURL: NSURL(string: imgUrl)!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            return UIImage(data: imgData)!
            
        } catch {
            throw Error.SomeError
        }
    }
    
    func getPhotoDictFromID(id: String) throws -> AnyObject {
        let url = "https://api.500px.com/v1/photos/\(id)?image_size=4&consumer_key=MFi9GRap6ormQLI5zMRvgrU7eWL5QR6JizxiKetP"
        print("URL: \(url)")
        
        do {
            let data = try NSData(contentsOfURL: NSURL(string: url)!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            print("JSON: \(json)")
            
            return json
            
        } catch {
            throw Error.SomeError
        }
    }
    
    func check(this: String, number: Int) {
        
        guard let d = NSUserDefaults(suiteName: "group.finngaida.photoviewer") else {return}
        if (number > d.integerForKey("highest")) {
            d.setInteger(number, forKey: "highest")
        }
        
        print("writing \(this) to cache")
        
        d.setValue(this, forKey: "\(number)")
        
    }
    
    func cache() -> String {
        let caches = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true) as [String]
        return caches[0]
    }
    
}
