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
    
    var overlayView:UIView!
    var overlayLabel:UILabel!
    
    var offsetDenominator:CGFloat!
    let TARGER_COLOR = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
    
    var textViewHeight: CGFloat = 0;
    
    var temp1: CGFloat = 0.00
    var temp2: CGFloat = 0.00
    var finalXPosition: CGFloat = 0.00
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {

        UIApplication.shared.statusBarStyle = .default
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(SharingClicked))

        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.CUSTOM_TableView.tableHeaderView = HeaderView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250))
        
        if let navCtrl = self.navigationController {
            self.offsetDenominator = (self.CUSTOM_TableView.tableHeaderView?.frame.size.height)! - navCtrl.navigationBar.frame.height
            
            let targetCIColor = CIColor(cgColor: self.TARGER_COLOR.cgColor)
            let overlayColor = UIColor(red: targetCIColor.red, green: targetCIColor.green, blue: targetCIColor.blue, alpha: 0.0)
            
            self.overlayView = UIView(frame: CGRect(x:0.0, y:0.0, width:self.view.bounds.width, height:64))
            self.overlayView.backgroundColor = overlayColor
            self.overlayView.clipsToBounds = true
            self.view.addSubview(self.overlayView)
            
            overlayLabel = UILabel(frame: CGRect(x: 8, y: 185, width: 320, height: FindHeight(fontSize:UIFont.boldSystemFont(ofSize: 25), text:appDelegate.objModelCollection.title)))
            overlayLabel.center = self.view.convert((self.CUSTOM_TableView.tableHeaderView?.viewWithTag(124)?.center)!, from: self.CUSTOM_TableView)
            overlayLabel.textAlignment = .left
            overlayLabel.text = appDelegate.objModelCollection.title
            overlayLabel.font = UIFont.boldSystemFont(ofSize: 25)
            overlayLabel.numberOfLines = 4
            self.view.addSubview(overlayLabel)
        }
        
        temp1 = self.view.center.x - overlayLabel.center.x
        temp2 = temp1/20.0
        finalXPosition = 0.00
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.backItem?.title = "PHUN APP"
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
 
    func FindHeight(fontSize:UIFont, text:String) -> Int {
    
        let font = fontSize
        let text = text
        let textString = text as NSString
        let textAttributes = [NSFontAttributeName: font]
        let textRect = textString.boundingRect(with: CGSize(width:self.CUSTOM_TableView.bounds.width, height:0), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        
        return Int(textRect.height)
    }
    
    // MARK: - Scrollview data source
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let headerView = self.CUSTOM_TableView.tableHeaderView as! HeaderView
        headerView.scrollViewDidScroll(scrollView)
        
        if let _ = self.navigationController, let breakpoint = offsetDenominator {
            
            let alpha = scrollView.contentOffset.y / breakpoint
            
            if alpha >= 1.0  {

            }
            else {
                
                let targetCIColor = CIColor(cgColor: self.TARGER_COLOR.cgColor)
                let overlayColor = UIColor(red: targetCIColor.red, green: targetCIColor.green, blue: targetCIColor.blue, alpha: alpha)
                self.overlayView.backgroundColor = overlayColor
                self.navigationController?.navigationBar.tintColor = UIColor.white
            }
        }

        let behindLabel: CGPoint = self.view.convert((self.CUSTOM_TableView.tableHeaderView?.viewWithTag(124)?.center)!, from: self.CUSTOM_TableView)
        
        if (scrollView.contentOffset.y >= 144.000 && scrollView.contentOffset.y <= 164.000) {
            
            self.navigationController?.navigationBar.tintColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            
            finalXPosition = behindLabel.x + ((scrollView.contentOffset.y.truncatingRemainder(dividingBy: 144.0))*temp2)

            overlayLabel.center = CGPoint(x:finalXPosition, y:behindLabel.y)
            
            overlayLabel.textAlignment = .center
            overlayLabel.font = UIFont.boldSystemFont(ofSize: 16)
        }
        else if (scrollView.contentOffset.y >= 164.001) {
            
            self.navigationController?.navigationBar.tintColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)

            let targetCIColor = CIColor(cgColor: self.TARGER_COLOR.cgColor)
            let overlayColor = UIColor(red: targetCIColor.red, green: targetCIColor.green, blue: targetCIColor.blue, alpha: 1.0)
            self.overlayView.backgroundColor = overlayColor
            
            overlayLabel.center = CGPoint(x:self.view.center.x, y:41)
            
            overlayLabel.textAlignment = .center
            overlayLabel.font = UIFont.boldSystemFont(ofSize: 16)
        }
        else {
                        
            overlayLabel.textAlignment = .left
            overlayLabel.font = UIFont.boldSystemFont(ofSize: 25)

            self.navigationController?.navigationBar.tintColor = UIColor.white
            
            overlayLabel.center = behindLabel
        }
    }

    // MARK: - Tableview data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(FindHeight(fontSize:UIFont.systemFont(ofSize: 13), text:appDelegate.objModelCollection.description)) + 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "CUSTOM_TableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! CUSTOM_TableViewCell
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        cell.lblDescription.frame = CGRect(x: 3, y: 43, width: Int(self.view.bounds.width)-6, height: FindHeight(fontSize:UIFont.systemFont(ofSize: 13), text:appDelegate.objModelCollection.description)+20)

        cell.lblLocation_1.text = appDelegate.objModelCollection.locationLine1
        cell.lblLocation_2.text = appDelegate.objModelCollection.locationLine2
        cell.lblDescription.text = appDelegate.objModelCollection.description
        
        return cell
    }
    
    @IBAction func shareButtonClicked(sender: UIButton) {
        let textToShare = "Swift is awesome!  Check out this website about it!"
        
        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func SharingClicked(_ sender: AnyObject) {

        var activityItems: [AnyObject]?
        
        if appDelegate.objModelCollection.imageURL.contains("NoValue") {
            
            activityItems = [appDelegate.objModelCollection.description as AnyObject, appDelegate.objModelCollection.locationLine1 as AnyObject, appDelegate.objModelCollection.locationLine2 as AnyObject]
        }
        else {
            
            activityItems = [appDelegate.objModelCollection.description as AnyObject, appDelegate.objModelCollection.locationLine1 as AnyObject, appDelegate.objModelCollection.locationLine2 as AnyObject, (self.CUSTOM_TableView.tableHeaderView?.viewWithTag(123) as! UIImageView).image!]
        }

        let activityViewController = UIActivityViewController(activityItems: activityItems!, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = sender as? UIView
        
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.barButtonItem = (sender as! UIBarButtonItem)
        }
        present(activityViewController, animated: true, completion: nil)
    }
}
