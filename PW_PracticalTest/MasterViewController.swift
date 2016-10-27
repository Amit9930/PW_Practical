//
//  ViewController.swift
//  PW_PracticalTest
//
//  Created by Amit Patel on 10/25/16.
//  Copyright © 2016 Amit Patel. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var CUSTOM_CollectionView: UICollectionView!
    
    var responseJSON: NSMutableArray = []
    var images_cache: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fetchJSONContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
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

    func loadingImage(link:String, imageview:UIImageView)
    {

        let url:NSURL = NSURL(string: link)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url as URL)
        request.timeoutInterval = 200
        
        
        let task = session.dataTask(with: request as URLRequest) {
            
            ( data, response, error) in

            guard let _:NSData = data as NSData?, let _:URLResponse = response  , error == nil else {
                
                return
            }
            
            
            var image = UIImage(data: data!)
            
            if (image != nil)
            {
                DispatchQueue.main.async {
                    self.writeFile(imageName: link, writeImage: image!)
                }
                
                
                func set_image()
                {
                    imageview.image = image
                }

                DispatchQueue.main.async(execute: set_image)
            }
            
        }
        
        task.resume()
        
    }
    
    // Read Write images into File
    
    func removeSpecialCharsFromString(str: String) -> String {
        let chars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890".characters)
        return String(str.characters.filter { chars.contains($0) })
    }

    func writeFile(imageName:String, writeImage:UIImage) {
        
        do {
            
            let fileManager = FileManager.default
            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(removeSpecialCharsFromString(str: imageName)).jpg")
            let imageData = UIImageJPEGRepresentation(writeImage, 0.7)
            fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        }
    }
    
    func readFile(imageName:String) -> UIImage {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("\(removeSpecialCharsFromString(str: imageName)).jpg").path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)!
        }
        return UIImage()
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

        let namePredicate = NSPredicate(format: "self = %@",objModelCollection.imageURL)
        let imageLinkArray = images_cache as NSArray
        
        let filteredArray: NSArray = imageLinkArray.filter { namePredicate.evaluate(with: $0) } as NSArray
        
        if (filteredArray.count > 0) {
            
            print("from caching \(indexPath.row) \(images_cache.object(at: indexPath.row))")

            DispatchQueue.main.async(execute: {
                
                if objModelCollection.imageURL.contains("NoValue") {
                    
                    cell.gridImageView.image = UIImage(named: "placeholder_nomoon")
                }
                else {
                    cell.gridImageView?.image = self.readFile(imageName: objModelCollection.imageURL)
                }
            })
        }
        else {
            
            images_cache.add(objModelCollection.imageURL)
            
            if objModelCollection.imageURL.contains("NoValue") {
    
                cell.gridImageView.image = UIImage(named: "placeholder_nomoon")
            }
            else {
                loadingImage(link: objModelCollection.imageURL, imageview: cell.gridImageView)
            }
        }

        return cell
    }
    
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width:UIScreen.main.bounds.width,height:220)
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objModelCollection = responseJSON.object(at : (indexPath as NSIndexPath).row) as! ModelCollection
    }
}

