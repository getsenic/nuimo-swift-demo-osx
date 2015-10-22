//
//  ViewController.swift
//  NuimoDemoOSX
//
//  Created by Lars Blumberg on 10/19/15.
//  Copyright © 2015 senic. All rights reserved.
//

import Cocoa
import NuimoSwift

class ViewController: NSViewController, NuimoDiscoveryDelegate, NuimoControllerDelegate {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet var textView: NSTextView!
    
    private let discoveryManager = NuimoDiscoveryManager.sharedManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        discoveryManager.delegate = self
        discoveryManager.webSocketControllerURLs = ["ws://localhost:9999"]
        
        startDiscovery(self)
    }
    
    func log(message: String, controller: NuimoController? = nil) {
        let prefix = controller != nil ? "[\(controller!.uuid)] " : ""
        textView.textStorage?.appendAttributedString(NSAttributedString(string: "\(prefix)\(message)\n"))
        textView.scrollToEndOfDocument(self)
    }
    
    @IBAction func startDiscovery(sender: AnyObject) {
        (tableView.dataSource() as! NuimoTableViewDataSource).controllers = []
        tableView.reloadData()
        log("Discovery started")
        discoveryManager.startDiscovery()
    }
    
    @IBAction func stopDiscovery(sender: AnyObject) {
        discoveryManager.stopDiscovery()
        log("Discovery stopped")
    }
    
    //MARK: NuimoDiscoveryDelegate

    func nuimoDiscoveryManager(discovery: NuimoDiscoveryManager, didDiscoverNuimoController controller: NuimoController) {
        log("Found controller \(controller.uuid)")
        if controller.state == .Disconnected {
            controller.delegate = self
            log("Trying to connect to controller")
            controller.connect()
        }
        (tableView.dataSource() as! NuimoTableViewDataSource).controllers += [controller]
        tableView.reloadData()
    }
    
    //MARK: NuimoControllerDelegate
    
    func nuimoController(controller: NuimoController, didReceiveGestureEvent gestureEvent: NuimoGestureEvent) {
        log("\(gestureEvent.gesture.identifier), value: \(gestureEvent.value ?? 0)", controller: controller)
    }
}
