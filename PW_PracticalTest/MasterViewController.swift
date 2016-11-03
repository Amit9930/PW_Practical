//
//  ViewController.swift
//  PW_PracticalTest
//
//  Created by Amit Patel on 10/25/16.
//  Copyright © 2016 Amit Patel. All rights reserved.
//

import UIKit
import AlamofireImage

class MasterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var CUSTOM_CollectionView: UICollectionView!
    
    var responseJSON: NSMutableArray = []
    var images_cache: NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        fetchJSONContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationItem.title = "PHUN APP"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchJSONContent() {
        
        if let path = Bundle.main.url(forResource: "DataFile", withExtension:"json")
        {
            
            if let jsonData = NSData(contentsOf: path) {
                do
                {
                    let responseArray: Array = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray as Array
                    
                    for (index, element) in responseArray.enumerated() {
                        
                        let elementDict:NSDictionary = element as! NSDictionary
                       
                        let objModelCollection:ModelCollection = ModelCollection(itemId: elementDict.value(forKey: "id") as? Int ?? 0,
                                        date: elementDict.value(forKey: "date") as? String ?? "",
                                        description: elementDict.value(forKey: "description") as? String ?? "",
                                        imageURL: elementDict.value(forKey: "image") as? String ?? "\(index)NoValue",
                                        locationLine1: elementDict.value(forKey: "locationline1") as? String ?? "",
                                        locationLine2: elementDict.value(forKey: "locationline2") as? String ?? "",
                                        timestamp: elementDict.value(forKey: "timestamp") as? String ?? "",
                                        title: elementDict.value(forKey: "title") as? String ?? "")
                        
                        responseJSON.add(objModelCollection)
                    }
                } catch {
                    print("Error!! Unable to parse  DataFile.json")
                }
            }
        }
    }
    
    // CollectionView delegate methods
    
    let reuseIdentifier = "CUSTOM_CollectionViewCell"

    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.responseJSON.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CUSTOM_CollectionViewCell
        
        let objModelCollection:ModelCollection = responseJSON.object(at : (indexPath as NSIndexPath).row) as! ModelCollection

        if objModelCollection.imageURL.contains("NoValue") {

            cell.gridImageView.image = UIImage(named: "placeholder_nomoon")
        }
        else {
            cell.gridImageView.af_setImage(withURL: URL(string: objModelCollection.imageURL)!)
        }

        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objModelCollection = responseJSON.object(at : (indexPath as NSIndexPath).row) as! ModelCollection
        
        let transition: CATransition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController!.view.layer.add(transition, forKey: nil)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var sizeOfCell: CGSize = CGSize(width:0, height:0)
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
            
            sizeOfCell = CGSize(width:UIScreen.main.bounds.width/2, height:220)
        } else {
            
            sizeOfCell = CGSize(width:UIScreen.main.bounds.width, height:220)
        }

        return sizeOfCell
    }
}

