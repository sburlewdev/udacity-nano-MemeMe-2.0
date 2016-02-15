//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Shawn Burlew on 2/10/16.
//  Copyright © 2016 Shawn Burlew. All rights reserved.
//

import UIKit

protocol DeleteMemeDelegate {
  func didDeleteMeme(atIndexPath indexPath: NSIndexPath)
}

class MemeViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var deleteButton: UIBarButtonItem!
  
  var image: UIImage!
  
  var makeImageFullScreen: Bool!
  
  let scale: CGFloat = 0.75
  
  // This is sent to DeleteMemeDelegate.didDeleteMeme(atIndexPath:)
  var indexPathToDelete: NSIndexPath!
  
  // Handles graceful deletion animations in table or collection views
  var delegate: DeleteMemeDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setBackgroundColors(.whiteColor())
    
    // Configure image view for scaled-down size
    self.imageView.frame = self.view.frame
    self.imageView.center = self.view.center
    self.setImageForScale(self.scale)
    
    // Table or collection cell will set image
    guard self.image != nil else {
      print("MemeViewController: Error - image does not exist.")
      self.imageView.userInteractionEnabled = false
      return
    }
    self.imageView.image = self.image
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Hide tab bar for meme detail view
    UIView.animateWithDuration(0.3) {
      self.hideTabBar()
    }
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Show tab bar for list and grid views
    UIView.animateWithDuration(0.3) {
      self.showTabBar()
    }
  }
  
  override func prefersStatusBarHidden() -> Bool {
    // Toggle status bar on and off depending on the size of the image view
    if self.makeImageFullScreen == nil {
      return false
    }
    return self.makeImageFullScreen
  }
  
  @IBAction func tappedImage(sender: AnyObject) {
    // The first time a user taps the image, make sure that it scales the image
    // up to full screen as expected.
    if self.makeImageFullScreen == nil {
      self.makeImageFullScreen = true
    }
    UIView.animateWithDuration(0.3) {
      if self.makeImageFullScreen! {
        self.setBackgroundColors(.blackColor())
        self.setImageForScale(nil)
        self.hideNavBar()
        self.makeImageFullScreen = false
      } else {
        self.setBackgroundColors(.whiteColor())
        self.setImageForScale(self.scale)
        self.showNavBar()
        self.makeImageFullScreen = true
      }
    } // UIView.animateWithDuration
  }
  
  @IBAction func actionWithMeme(sender: AnyObject) {
    let action = UIActivityViewController(activityItems: [self.image], applicationActivities: nil)
    self.presentViewController(action, animated: true, completion: nil)
  }
  
  @IBAction func deleteMeme(sender: AnyObject) {
    self.deleteMemeWithAnimation()
  }
  
  func deleteMemeWithAnimation() {
    let x: CGFloat = self.view.frame.width * 2.0
    let y: CGFloat = UIApplication.sharedApplication().statusBarFrame.height
    // Make image spin as it starts to move towards deleteButton
    UIView.animateWithDuration(0.1,
      delay: 0.0,
      options: [.Repeat],
      animations: {
        self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(M_1_PI))
      },
      completion: nil)
    // Move image towards deleteButton, shrink its size to zero and make it fade
    // to transparent
    UIView.animateWithDuration(0.5,
      animations: {
        self.imageView.center = CGPoint(x: x, y: y)
        self.imageView.frame.size = CGSize(width: 0, height: 0)
        self.imageView.alpha = 0.0
      },
      completion: { _ in
        // Once image has disappeared, move back out to table or collection view
        // while animating the meme's deletion properly
        self.delegate.didDeleteMeme(atIndexPath: self.indexPathToDelete)
        self.navigationController!.popToRootViewControllerAnimated(true)
    })
  }
  
  // Handle tab bar position
  
  func hideTabBar() {
    // If tab bar is inside the view's frame, then move it out
    if self.tabBarController!.tabBar.center.y < self.view.frame.height {
      self.tabBarController!.tabBar.center.y += self.tabBarController!.tabBar.frame.height
    }
  }
  
  func showTabBar() {
    // If tab bar is outside the view's frame, then move it in
    if self.tabBarController!.tabBar.center.y > self.view.frame.height {
      self.tabBarController!.tabBar.center.y -= self.tabBarController!.tabBar.frame.height
    }
  }
  
  // Handle navigation bar position
  
  func hideNavBar() {
    // If nav bar is inside the view's frame, then move it out
    self.setNeedsStatusBarAppearanceUpdate()
    if self.navigationController!.navigationBar.center.y > 0 {
      self.navigationController!.navigationBar.center.y -= self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height
    }
  }
  
  func showNavBar() {
    // If nav bar is outside the view's frame, then move it in
    self.setNeedsStatusBarAppearanceUpdate()
    if self.navigationController!.navigationBar.center.y < 0 {
      self.navigationController!.navigationBar.center.y += self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height
    }
  }
  
  // Handle image scaling
  
  func setImageForScale(scale: CGFloat?) {
    if let scale = scale {
      // Scale image view based on parameter
      self.imageView.transform = CGAffineTransformMakeScale(scale, scale)
    } else {
      // Set image view to full screen
      self.imageView.frame = self.view.frame
    }
  }
  
  // Handle colors
  
  func setBackgroundColors(color: UIColor) {
    self.view.backgroundColor = color
    self.tabBarController!.tabBar.backgroundColor = color
    self.navigationController!.navigationBar.backgroundColor = color
  }
}