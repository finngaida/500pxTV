//
//  DetailViewController.swift
//  500px
//
//  Created by Finn Gaida on 09.11.15.
//  Copyright © 2015 Finn Gaida. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sideImageView: UIImageView!
    @IBOutlet weak var titleHeadline: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistHeadline: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var descriptionHeadline: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var cameraHeadline: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var objectiveLabel: UILabel!
    @IBOutlet weak var apertureLabel: UILabel!
    var photo: NSDictionary?
    
    enum Error:ErrorType {
        case ValueMissing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let p = photo {
            
            titleLabel.text = p["name"] as? String ?? "no title"
            cameraLabel.text = p["camera"] as? String ?? "no camera"
            objectiveLabel.text = p["lens"] as? String ?? "no lens"
            descriptionLabel.text = p["description"] as? String ?? "no title"
            
            var apertureLabelText = ""
            if let aperture = p["aperture"] as? String where aperture.characters.count > 0 {
                apertureLabelText = "ƒ/\(aperture)"
            }
            
//                if let focal = p["focal_length"] as? String where focal.characters.count > 0 {
//                    apertureLabelText += " | \(focal)mm"
//                }
            
            if let speed = p["shutter_speed"] as? String where speed.characters.count > 0 {
                apertureLabelText += " | \(speed)s"
            }
            
            if let iso = p["iso"] as? String where iso.characters.count > 0 {
                apertureLabelText += " | ISO \(iso)"
            }
            apertureLabel.text = apertureLabelText
            
            if let u = p["user"] {
                artistLabel.text = u["fullname"] as? String ?? "no artist"
            }
            
            let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
            blur.frame = sideImageView.frame
            sideImageView.addSubview(blur)
            
            let vibrancy = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blur.effect as! UIBlurEffect))
            blur.contentView.addSubview(vibrancy)
            
            print(p["id"])
            
            if let id = p["id"] {
                do {
                    let im = try Network().getPhotoFromID("\(id)")
                    imageView.image = im
                    sideImageView.image = im
                } catch {
                    print("Couldn't load image \(p)")
                }
            } else {
                print("WTF?")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
