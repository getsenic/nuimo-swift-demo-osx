//
//  NuimoDataSource.swift
//  NuimoDemoOSX
//
//  Created by Lars Blumberg on 10/19/15.
//  Copyright © 2015 senic. All rights reserved.
//

import Cocoa
import NuimoSwift

class NuimoTableViewDataSource : NSObject, NSTableViewDataSource {
    var controllers = [NuimoController]()
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return controllers.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return controllers[row].uuid
    }
}
