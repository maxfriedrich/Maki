//
//  BrowseServicesViewController.swift
//  Maki-iOS
//

import UIKit
import Foundation

class BrowseServicesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let reuseIdentifier = "BrowseServicesCell"
    
    var tableView: UITableView!
    
    var serviceBrowser: ServiceBrowser?
    var services: [NetService] = []
    var serviceResolver: ServiceResolver?
    var didSelectService: ((String, UInt, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select a Device"
        
        tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        serviceBrowser = ServiceBrowser()
        serviceBrowser!.browse {[unowned self] services in
            self.services = services
            print("Got services: \(services)")
            self.tableView.reloadData()
            self.serviceBrowser = nil
        }
    }
    
    
    // MARK: Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrowseServicesCell")!
        cell.textLabel?.text = services[indexPath.row].name 
        return cell
    }
    
    // MARK: Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        serviceResolver = ServiceResolver()
        serviceResolver!.resolve(service: services[indexPath.row], didResolveBlock: {[unowned self] host, port, name in
            self.didSelectService?(host, port, name)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
}
