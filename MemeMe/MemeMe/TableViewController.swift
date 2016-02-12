//
//  TableViewController.swift
//  MemeMe
//
//  Created by Shawn Burlew on 2/9/16.
//  Copyright © 2016 Shawn Burlew. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
  
  let data = Data.sharedInstance
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.tableView.reloadData()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "MemeDetail" {
      let detail = segue.destinationViewController as! MemeDetailViewController
      let cell = sender as! MemeTableCell
      
      /*
      guard let index = self.tableView.indexPathForCell(cell)?.row else {
        print("Error - could not find cell.")
        return
      }*/
      
      let index = self.tableView.indexPathForCell(cell)!.row
      guard let image = self.data.getMeme(atIndex: index)?.memedImage else {
        print("Error - could not retrieve image.")
        return
      }
      
      detail.image = image
    }
  }
  
  // UITableViewDataSource
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCellWithIdentifier("MemeTableCell")! as! MemeTableCell
    let meme = data.getMeme(atIndex: indexPath.row)!
    cell.memeImage.image = meme.memedImage
    cell.memeLabel.text = meme.topText + "..." + meme.bottomText
    return cell
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      self.data.deleteMeme(atIndex: indexPath.row)
      self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.getMemesCount()
  }
  
  // UITableViewDelegate
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 80.0
  }
}