//
//  ViewController.swift
//  NuimoDemoOSX
//
//  Created by Lars Blumberg on 10/19/15.
//  Copyright © 2015 senic. All rights reserved.
//

import Cocoa
import NuimoSwift

class ViewController: NSViewController, NuimoDiscoveryDelegate {

    @IBOutlet weak var tableView: NSTableView!
    
    private let discoveryManager = NuimoDiscoveryManager.sharedManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        discoveryManager.delegate = self
        discoveryManager.discoverControllers()
        
        print("Discovering controllers")
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func startDiscovery(sender: NSButton) {
        (tableView.dataSource() as! NuimoTableViewDataSource).controllers = []
        tableView.reloadData()
        discoveryManager.discoverControllers()
    }
    
    @IBAction func stopDiscovery(sender: NSButton) {
        discoveryManager.stopDiscovery()
    }

    func nuimoDiscoveryManager(discovery: NuimoDiscoveryManager, didDiscoverNuimoController controller: NuimoController) {
        print(controller.uuid)
        (tableView.dataSource() as! NuimoTableViewDataSource).controllers += [controller]
        tableView.reloadData()
    }
}
