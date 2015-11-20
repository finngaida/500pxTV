//
//  PopularCollectionViewController.swift
//  500px
//
//  Created by Finn Gaida on 06.10.15.
//  Copyright © 2015 Finn Gaida. All rights reserved.
//

import UIKit

private let reuseIdentifier = "piccell"

class BaseCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var photos:Array<AnyObject>?
    var feature = "SUBCLASS_AND_SET_FEATURE_HERE"
    var pages = 1
    var spinner:UIActivityIndicatorView?
    var firstLoad = false
    
//    override var preferredFocusedView: UIView? {
//        self.setNeedsFocusUpdate()
//        self.updateFocusIfNeeded()
//        return self.collectionView
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView?.remembersLastFocusedIndexPath = true
        // Do any additional setup after loading the view.
//        self.view.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        
        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        self.spinner?.center = self.view.center
        self.spinner?.tintColor = UIColor.blackColor()
        self.view.addSubview(self.spinner!)
        self.spinner?.startAnimating()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "delegateCall:", name: "topShelfOpen", object: nil)
        
        firstLoad = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if (firstLoad) {
            reload()
        }
        
        firstLoad = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reload() {
        
        if (feature != "SUBCLASS_AND_SET_FEATURE_HERE") {
            Network().getPhotos(feature, sort: "created_at", imageSize: 3, pages: pages) { (dict) -> () in
                self.photos = dict
                self.pages++
                self.collectionView?.reloadData()
                
//                print(dict)
                
                self.spinner?.stopAnimating()
                self.spinner?.removeFromSuperview()
            }
        }
    }
    
    func delegateCall(sender: NSNotification) {
        
        print(sender.object!)
        
        if let number = sender.object {
            self.performSegueWithIdentifier("showDetail", sender: number)
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let p:CGFloat = 40
        return UIEdgeInsetsMake(self.view.frame.width/15 + p, p, p*1.5, p)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 40
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.view.frame.width/7, self.view.frame.width/7)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
//        if (indexPath.row == 0) {print(photos![0])}
        
        let photo = photos![indexPath.row]["image_url"] as! String
        let name = photos![indexPath.row]["name"] as! String
        let user = photos![indexPath.row]["user"]!!["fullname"] as! String
        
        do {
            
            let url = NSURL(string: photo)
            let data = try NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            let im = UIImage(data: data)
            
            // save first 5 to file for top shelf imagery
            if (indexPath.row < 15) {
                Network().check(photo, number: indexPath.row)
            }
            
            (cell as? PicCell)?.setImage(im!, title: name, artist: user)
            
        } catch {
            print("error here: \(error)")
        }
        
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        let _ = (context.focusHeading.rawValue == 1) ? "Up" : (context.focusHeading.rawValue == 2) ? "Down" : (context.focusHeading.rawValue == 4) ? "Left" : (context.focusHeading.rawValue == 8) ? "Right" : "WTF"
        
//        if let lastcell = context.previouslyFocusedView as? UICollectionViewCell {
//            coordinator.addCoordinatedAnimations({ () -> Void in
//                
//                //                lastcell.contentView.frame = CGRectMake(0, 0, lastcell.contentView.frame.width/0.8, lastcell.contentView.frame.height/0.8)
//                lastcell.transform = CGAffineTransformMakeScale(1.0, 1.0)
//                
//                }, completion: { () -> Void in})
//        }
//        
//        if let nextcell = context.nextFocusedView as? UICollectionViewCell {
//            coordinator.addCoordinatedAnimations({ () -> Void in
//                
//                //                nextcell.contentView.frame = CGRectMake(nextcell.contentView.frame.width*0.1, nextcell.contentView.frame.height*0.1, nextcell.contentView.frame.width*0.8, nextcell.contentView.frame.height*0.8)
//                nextcell.transform = CGAffineTransformMakeScale(0.8, 0.8)
//                
//                }, completion: { () -> Void in})
//        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.performSegueWithIdentifier("showDetail", sender: indexPath.row)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, shouldUpdateFocusInContext context: UICollectionViewFocusUpdateContext) -> Bool {
        return true
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y >= scrollView.contentSize.height-1100) {
            reload()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetail") {
            
            let dest = segue.destinationViewController as? DetailViewController
            
            let index = Int("\(sender!)")
            dest?.photo = photos![index!] as? NSDictionary
            
        }
    }
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
}
