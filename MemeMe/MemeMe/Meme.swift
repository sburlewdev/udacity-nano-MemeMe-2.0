//
//  Meme.swift
//  MemeMe
//
//  Created by Shawn Burlew on 2/8/16.
//  Copyright © 2016 Shawn Burlew. All rights reserved.
//

import UIKit

class Meme: NSObject, NSCoding {
  
  var topText: String!
  var bottomText: String!
  var originalImage: UIImage!
  var memedImage: UIImage!
  
  // Initialize via decoder
  required init?(coder aDecoder:NSCoder) {
    self.topText = aDecoder.decodeObjectForKey("topText") as! String
    self.bottomText = aDecoder.decodeObjectForKey("bottomText") as! String
    self.originalImage = aDecoder.decodeObjectForKey("originalImage") as! UIImage
    self.memedImage = aDecoder.decodeObjectForKey("memedImage") as! UIImage
    super.init()
  }
  
  override init() {
    super.init()
  }
  
  // Initialize via code
  init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
    self.topText = topText
    self.bottomText = bottomText
    self.originalImage = originalImage
    self.memedImage = memedImage
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.topText, forKey: "topText")
    aCoder.encodeObject(self.bottomText, forKey: "bottomText")
    aCoder.encodeObject(self.originalImage, forKey: "originalImage")
    aCoder.encodeObject(self.memedImage, forKey: "memedImage")
  }
}