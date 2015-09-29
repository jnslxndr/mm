//
//  StatusMenuController.swift
//  mm
//
//  Created by jens on 29.09.15.
//  Copyright © 2015 lea.io. All rights reserved.
//

import Cocoa
import SystemKit

class StatusMenuController: NSObject {
  @IBOutlet weak var statusMenu: NSMenu!
  
  let statusItem: NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
  
  var timer: NSTimer! = nil
  var sys = System()
  let icon : NSImage!
  var _interval = 1.0
  var interval:Double {
    set {
      _interval = max(min(newValue, 10),0.25)
    }
    get {
      return _interval
    }
  }
  
  internal override init() {
    
    icon = NSImage.init(size: NSSize(width: 4,height: 18))
    
    super.init()

    let defaults = NSUserDefaults.standardUserDefaults()
    let defaultInterval = defaults.doubleForKey("interval")
    
    if defaultInterval == 0.0 {
      saveInterval()
    }
    
    interval = defaultInterval
    
//    print("// MACHINE STATUS")
//    
//    print("\n-- CPU --")
//    print("\tPHYSICAL CORES:  \(System.physicalCores())")
//    print("\tLOGICAL CORES:   \(System.logicalCores())")
//    
//    let cpuUsage = sys.usageCPU()
//    print("\tSYSTEM:          \(Int(cpuUsage.system))%")
//    print("\tUSER:            \(Int(cpuUsage.user))%")
//    print("\tIDLE:            \(Int(cpuUsage.idle))%")
//    print("\tNICE:            \(Int(cpuUsage.nice))%")
  }
  
  private func saveInterval() {
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setDouble(interval, forKey: "interval")
  }
  
  override func awakeFromNib() {

    statusItem.image = icon
    statusItem.image?.template = true
    
    statusItem.menu = statusMenu
    
    timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("tick:"), userInfo: nil, repeats: true)
    
  }

  func tick(timer: NSTimer) {
    NSLog("tick")
    let cpu = sys.usageCPU()
    let use = 100 - cpu.idle
//    NSLog("%f%",  icon.size.height * CGFloat(use) / 100)
    
    let rect = NSMakeRect(0, 0, icon.size.width, icon.size.height)
    let bar = NSMakeRect(0, 0, icon.size.width, icon.size.height * CGFloat(use) / 100)
    
    let bgc = NSColor.init(white: 1, alpha: 0)
    let fgc = NSColor.blackColor()
    
    icon.lockFocus()

    bgc.setFill()
    NSRectFill(rect)
    
    fgc.setFill()
    NSRectFill(bar)
    
    icon.unlockFocus()
    statusItem.image = icon
    
  }

}
