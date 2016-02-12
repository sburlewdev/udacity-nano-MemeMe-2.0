//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Shawn Burlew on 2/10/16.
//  Copyright © 2016 Shawn Burlew. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  
  var image: UIImage!
  
  var makeImageFullScreen: Bool!
  
  let scale: CGFloat = 0.75
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setBackgroundColors(.whiteColor())
    
    // Configure image view for scaled-down size
    self.imageView.frame = self.view.frame
    self.imageView.center = self.view.center
    self.setImageForScale(self.scale)
    
    print("View frame: \(self.view.frame)")
    
    // Table or collection cell will set image
    guard self.image != nil else {
      print("Error - self.image is nil.")
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
    guard self.makeImageFullScreen != nil else {
      return false
    }
    return self.makeImageFullScreen
  }
  
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
  
  func hideNavBar() {
    // If nav bar is inside the view's frame, then move it out
    if self.navigationController!.navigationBar.center.y > 0 {
      self.navigationController!.navigationBar.center.y -= self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height
    }
  }
  
  func showNavBar() {
    // If nav bar is outside the view's frame, then move it in
    if self.navigationController!.navigationBar.center.y < 0 {
      self.navigationController!.navigationBar.center.y += self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height
    }
  }
  
  func setImageForScale(scale: CGFloat?) {
    if let scale = scale {
      // Scale image view based on parameter
      self.imageView.transform = CGAffineTransformMakeScale(scale, scale)
    } else {
      // Set image view to full screen
      self.imageView.frame = self.view.frame
    }
  }
  
  func setBackgroundColors(color: UIColor) {
    self.view.backgroundColor = color
    self.tabBarController!.tabBar.backgroundColor = color
    self.navigationController!.navigationBar.backgroundColor = color
  }
  
  @IBAction func tappedImage(sender: AnyObject) {
    // The first time a user taps the image, make sure that it scales the image
    // up to full screen as expected.
    if self.makeImageFullScreen == nil {
      self.makeImageFullScreen = true
    }
    print("Make image full screen: \(self.makeImageFullScreen)")
    UIView.animateWithDuration(0.3) {
      self.setNeedsStatusBarAppearanceUpdate()
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
    print("Image frame: \(self.imageView.frame)")
  }
}