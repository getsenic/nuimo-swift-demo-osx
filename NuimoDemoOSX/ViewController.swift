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

    func log(controller: NuimoController, message: String) {
        textView.textStorage?.appendAttributedString(NSAttributedString(string: "[\(controller.uuid)] \(message)\n"))
        textView.scrollToEndOfDocument(self)
    }
    
    //MARK: NuimoDiscoveryDelegate

    func nuimoDiscoveryManager(discovery: NuimoDiscoveryManager, didDiscoverNuimoController controller: NuimoController) {
        log(controller, message: "Found controller")
        if controller.connectionState == .Disconnected {
            controller.delegate = self
            controller.connect()
        }
        (tableView.dataSource as! NuimoTableViewDataSource).controllers += [controller]
        tableView.reloadData()
    }

    func nuimoDiscoveryManager(discovery: NuimoDiscoveryManager, didInvalidateController controller: NuimoController) {
        (tableView.dataSource as! NuimoTableViewDataSource).controllers = (tableView.dataSource as! NuimoTableViewDataSource).controllers.filter{ $0 !== controller }
        tableView.reloadData()
    }
    
    //MARK: NuimoControllerDelegate
    
    func nuimoController(controller: NuimoController, didReceiveGestureEvent event: NuimoGestureEvent) {
        log(controller, message: "\(event.gesture.identifier), value: \(event.value ?? 0)")
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
