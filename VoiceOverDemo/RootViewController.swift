//
//  RootViewController.swift
//  VoiceOverDemo
//
//  Created by qiang xu on 2021/11/17.
//

import UIKit

enum DemoCase {
    case view
    case notification
    
    var name: String {
        switch self {
        case .view:
            return "Views"
        case .notification:
            return "Notificaitons"
        }
    }
    
    var providers: [ViewProviding] {
        switch self {
        case .view:
            return [
                ButtonProvider(),
                LabelProvider(),
                TextFieldProvider(),
                TextViewProvider(),
                SwitchProvider(),
                SliderProvider(),
                GroupContainerViewProvider(),
                BeforeReorderContainerViewProvider(),
                ReorderContainerViewProvider()
            ]
        case .notification:
            return []
        }
    }
}


class RootViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cases: [DemoCase] = [.view, .notification]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("VoiceOver Demo", comment: "")
        
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
    }
}

extension RootViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell()
        
        let theCase = cases[indexPath.item]
        cell.textLabel?.text = theCase.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cases[indexPath.item] {
        case .view:
            let providers = cases[indexPath.item].providers
            
            let contentViewController = ContentViewController(providers: providers)
            
            navigationController?.pushViewController(contentViewController, animated: true)
        case .notification:
            let vc = NotificationsController(nibName: nil, bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
       
    }
}

