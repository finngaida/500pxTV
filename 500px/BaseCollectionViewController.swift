//
//  PopularCollectionViewController.swift
//  500px
//
//  Created by Finn Gaida on 06.10.15.
//  Copyright © 2015 Finn Gaida. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class BaseCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var photos:Array<AnyObject>?
    var feature = "SUBCLASS AND SET FEATURE HERE"
    var pages = 1
    var spinner:UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.remembersLastFocusedIndexPath = true
        // Do any additional setup after loading the view.
        
        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        self.spinner?.center = self.view.center
        self.spinner?.tintColor = UIColor.blackColor()
        self.view.addSubview(self.spinner!)
        self.spinner?.startAnimating()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        reload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reload() {
        
        if (feature != "SUBCLASS AND SET FEATURE HERE") {
            Network().getPhotos(feature, sort: "created_at", imageSize: 3, pages: pages) { (dict) -> () in
                self.photos = dict
                self.pages++
                self.collectionView?.reloadData()
                
                self.spinner?.stopAnimating()
                self.spinner?.removeFromSuperview()
            }
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
        // #warning Incomplete implementation, return the number of items
        return photos?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(self.view.frame.width/15, 20, 20, 20)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.view.frame.width/7, self.view.frame.width/7)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        let photo = photos![indexPath.row]["image_url"] as! String
        
        // Configure the cell
        let img = UIImageView(frame: CGRectMake(0, 0, cell.frame.width, cell.frame.height))
        
        do {
            let url = NSURL(string: photo)
            let data = try NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            let im = UIImage(data: data)
            
            // save first 5 to file for top shelf imagery
            if (indexPath.row < 5) {
                Network().check(im!, number: indexPath.row)
            }
            
            img.image = im!
        } catch {
            print("error here: \(error)")
        }
        
        cell.contentView.addSubview(img)
        
        return cell
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
        
        if let lastcell = context.previouslyFocusedView as? UICollectionViewCell {
            coordinator.addCoordinatedAnimations({ () -> Void in
                
                //                lastcell.contentView.frame = CGRectMake(0, 0, lastcell.contentView.frame.width/0.8, lastcell.contentView.frame.height/0.8)
                lastcell.transform = CGAffineTransformMakeScale(1.0, 1.0)
                
                }, completion: { () -> Void in})
        }
        
        if let nextcell = context.nextFocusedView as? UICollectionViewCell {
            coordinator.addCoordinatedAnimations({ () -> Void in
                
                //                nextcell.contentView.frame = CGRectMake(nextcell.contentView.frame.width*0.1, nextcell.contentView.frame.height*0.1, nextcell.contentView.frame.width*0.8, nextcell.contentView.frame.height*0.8)
                nextcell.transform = CGAffineTransformMakeScale(0.8, 0.8)
                
                }, completion: { () -> Void in})
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("should show detail here")
    }
    
    override func collectionView(collectionView: UICollectionView, shouldUpdateFocusInContext context: UICollectionViewFocusUpdateContext) -> Bool {
        return true
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y >= scrollView.contentSize.height-1100) {
            reload()
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
