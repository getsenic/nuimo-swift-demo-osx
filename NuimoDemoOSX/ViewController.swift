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

    @IBOutlet weak var discoveryButton: NSButton!
    @IBOutlet weak var discoveryProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet var textView: NSTextView!
    
    private let discoveryManager = NuimoDiscoveryManager.sharedManager
    private var isDiscovering = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        discoveryManager.delegate = self
    }
    
    func log(message: String, controller: NuimoController? = nil) {
        let prefix = controller != nil ? "[\(controller!.uuid)] " : ""
        textView.textStorage?.appendAttributedString(NSAttributedString(string: "\(prefix)\(message)\n"))
        textView.scrollToEndOfDocument(self)
    }
    
    @IBAction func startStopDiscovery(sender: AnyObject) {
        isDiscovering = !isDiscovering
        if (isDiscovering) {
            discoveryManager.startDiscovery()
            discoveryProgressIndicator.startAnimation(self)
            discoveryButton.title = "Stop Discovery"
        }
        else {
            discoveryManager.stopDiscovery()
            discoveryProgressIndicator.stopAnimation(self)
            discoveryButton.title = "Discover Nuimos"
        }
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

    func nuimoDiscoveryManager(discovery: NuimoDiscoveryManager, didInvalidateController controller: NuimoController) {
        (tableView.dataSource() as! NuimoTableViewDataSource).controllers = (tableView.dataSource() as! NuimoTableViewDataSource).controllers.filter{ $0 !== controller }
        tableView.reloadData()
    }
    
    //MARK: NuimoControllerDelegate
    
    func nuimoController(controller: NuimoController, didReceiveGestureEvent event: NuimoGestureEvent) {
        log("\(event.gesture.identifier), value: \(event.value ?? 0)", controller: controller)
    }

    func nuimoControllerDidConnect(controller: NuimoController) {
        tableView.reloadData()
    }

    func nuimoController(controller: NuimoController, didFailToConnect error: NSError?) {
        tableView.reloadData()
    }

    func nuimoController(controller: NuimoController, didDisconnect error: NSError?) {
        tableView.reloadData()
    }
}
