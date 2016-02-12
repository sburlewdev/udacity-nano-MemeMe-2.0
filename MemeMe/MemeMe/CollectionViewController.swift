//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Shawn Burlew on 2/9/16.
//  Copyright © 2016 Shawn Burlew. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
  
  let data = Data.sharedInstance
  
  @IBOutlet var flowLayout: UICollectionViewFlowLayout!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let space: CGFloat = 3.0
    let dimension: CGFloat = (self.view.frame.width - (2.0 * space)) / 4.0
    
    // Set up flow layout
    flowLayout.minimumInteritemSpacing = space
    flowLayout.minimumLineSpacing = space
    flowLayout.itemSize = CGSize(width: dimension, height: dimension)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.collectionView!.reloadData()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "MemeDetail" {
      let detail = segue.destinationViewController as! MemeDetailViewController
      let index = self.collectionView!.indexPathForCell(sender as! MemeCollectionCell)!.row
      
      guard let image = self.data.getMeme(atIndex: index)?.memedImage else {
        print("CollectionViewController: Error - could not retrieve image.")
        return
      }
      detail.image = image
    }
  }
  
  // UICollectionViewDataSource
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = self.collectionView!.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionCell
    let meme = self.data.getMeme(atIndex: indexPath.row)!
    cell.memeImage.image = meme.memedImage
    return cell
  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.data.getMemesCount()
  }
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
}