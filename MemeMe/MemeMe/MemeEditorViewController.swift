//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Shawn Burlew on 2/8/16.
//  Copyright © 2016 Shawn Burlew. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {
  
  let data = Data.sharedInstance

  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  
  @IBOutlet weak var actionButton: UIBarButtonItem!
  
  @IBOutlet weak var topTextField: UITextField!
  
  @IBOutlet weak var bottomTextField: UITextField!
  
  @IBOutlet weak var navBar: UINavigationBar!
  
  @IBOutlet weak var toolBar: UIToolbar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    let memeTextAttributes = [
      NSStrokeColorAttributeName : UIColor.blackColor(),
      NSForegroundColorAttributeName : UIColor.whiteColor(),
      NSFontAttributeName :  UIFont(name: "HelveticaNeue-Bold", size: 40)!,
      NSStrokeWidthAttributeName : 3.0
    ]
    
    self.topTextField.defaultTextAttributes = memeTextAttributes
    self.bottomTextField.defaultTextAttributes = memeTextAttributes
    self.topTextField.sizeToFit()
    self.bottomTextField.sizeToFit()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    self.subscribeToKeyboardNotifications()
    self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
    
    self.toggleActionButton()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    self.unsubscribeFromKeyboardNotifications()
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  // Actions
  
  @IBAction func cancel(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func pickImageFromAlbum(sender: AnyObject) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .PhotoLibrary
    self.presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func pickImageFromCamera(sender: AnyObject) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .Camera
    self.presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func actionMemedImage(sender: AnyObject) {
    // Create meme
    let memedImage = self.generateMemedImage()
    let meme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imageView.image!, memedImage: memedImage)
    
    // Display activity view controller
    let activity = UIActivityViewController(activityItems: [self.generateMemedImage()], applicationActivities: nil)
    activity.completionWithItemsHandler = { (activityType: String?, completed: Bool, modifiedObjects: [AnyObject]?, error: NSError?)  in
      guard error == nil else {
        return
      }
      guard completed else {
        return
      }
      self.data.addMeme(meme)
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    self.presentViewController(activity, animated: true, completion: nil)
  }
  
  func toggleActionButton() {
    if self.imageView.image != nil {
      self.actionButton.enabled = true
    }
    else {
      self.actionButton.enabled = false
    }
  }
  
  // Generate meme
  
  func generateMemedImage() -> UIImage {
    
    // Hide tool bar and navigation bar before generating image
    self.navBar.hidden = true
    self.toolBar.hidden = true
    
    UIGraphicsBeginImageContext(self.view.frame.size)
    self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
    let memedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    self.navBar.hidden = false
    self.toolBar.hidden = false
    
    return memedImage
  }
  
  // Handle keyboard
  
  func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    let keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.CGRectValue().height
  }
  
  func keyboardWillHide(notification: NSNotification) {
    self.view.frame.origin.y += self.getKeyboardHeight(notification)
  }
  
  func keyboardWillShow(notification: NSNotification) {
    self.view.frame.origin.y -= self.getKeyboardHeight(notification)
  }
  
  func subscribeToKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  func unsubscribeFromKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
}

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      self.imageView.image = image
    }
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}