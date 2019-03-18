//
//  ViewController.swift
//  LocationUpdate
//
//  Created by Mayur on 11/03/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var savedProfile: NSDictionary?
    var locationArray: [NSDictionary]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        self.tableView.tableFooterView = UIView()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadData()
    }
    
    func reloadData() {
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fullPath = "\(docDir)/\("LocationArray.plist")"
        
        savedProfile = NSDictionary(contentsOfFile: fullPath)
        
        if (savedProfile != nil) {
            //Sort
            locationArray = (savedProfile?["LocationArray"] as? NSArray)?.sortedArray(using: [NSSortDescriptor(key: "Time", ascending: 0 != 0)]) as? [NSDictionary]
            if locationArray != nil {
                var temp: [Any] = []
                for dic in locationArray! {
                    if dic["Accuracy"] != nil {
                        temp.append(dic)
                    }
                }
                locationArray = temp as? [NSDictionary]
            }
        }
        
        tableView.reloadData()
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = locationArray?.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "location")!

        let dic = locationArray?[indexPath.row]
        
        let appState = "\(dic!.value(forKey: "AppState")!)"
        let date = dic?["Time"] as? Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        var time: String? = nil
        if let date = date {
            time = dateFormatter.string(from: date)
        }

        cell?.textLabel?.text = appState
        cell?.detailTextLabel?.text = time
        
        return cell!
    }
}
