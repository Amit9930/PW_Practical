//
//  DetailViewController.swift
//  PW_PracticalTest
//
//  Created by Amit Patel on 10/25/16.
//  Copyright © 2016 Amit Patel. All rights reserved.
//

import UIKit
import Foundation

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var CUSTOM_TableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.backItem?.title = ""

        self.CUSTOM_TableView.tableHeaderView = HeaderView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200));
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let headerView = self.CUSTOM_TableView.tableHeaderView as! HeaderView
        headerView.scrollViewDidScroll(scrollView)
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "CUSTOM_TableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! CUSTOM_TableViewCell
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        cell.textView.text = appDelegate.objModelCollection.description
        cell.lblLocation_1.text = appDelegate.objModelCollection.locationLine1
        cell.lblLocation_2.text = appDelegate.objModelCollection.locationLine2
        
        return cell
    }
}
