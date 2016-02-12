//
//  Data.swift
//  MemeMe
//
//  Created by Shawn Burlew on 2/9/16.
//  Copyright © 2016 Shawn Burlew. All rights reserved.
//

import UIKit

class Data {
  
  // Singleton class variable
  static let sharedInstance: Data = Data()
  
  private var memes = [Meme]()
  
  private init() {
    self.loadMemes()
  }
  
  // Manage memes list
  
  func getMeme(atIndex index: Int) -> Meme? {
    guard index >= 0 && index < self.memes.count else {
      return nil
    }
    return self.memes[index]
  }
  
  func getMemesCount() -> Int {
    return self.memes.count
  }
  
  func addMeme(meme: Meme) {
    self.memes.append(meme)
    self.saveMemes()
  }
  
  func deleteMeme(atIndex index: Int) {
    guard index >= 0 && index < self.memes.count else {
      return
    }
    self.memes.removeAtIndex(index)
    self.saveMemes()
  }
  
  // Persist memes list
  
  func loadMemes() {
    if NSFileManager.defaultManager().fileExistsAtPath(self.memesFilePath()) {
      guard let data = NSData(contentsOfFile: self.memesFilePath()) else {
        return
      }
      let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
      self.memes = unarchiver.decodeObjectForKey("memes") as! [Meme]
    }
  }
  
  func saveMemes() {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
    archiver.encodeObject(self.memes, forKey: "memes")
    archiver.finishEncoding()
    data.writeToFile(memesFilePath(), atomically: true)
  }
  
  func memesFilePath() -> String {
    let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    return (path as NSString).stringByAppendingPathComponent("Memes.plist")
  }
}