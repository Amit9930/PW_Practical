//
//  ModelCollection.swift
//  PW_PracticalTest
//
//  Created by Amit Patel on 10/26/16.
//  Copyright © 2016 Amit Patel. All rights reserved.
//

class ModelCollection {

    let itemId: Int
    var date: String
    var description: String
    var imageURL: String
    var locationLine1: String
    var locationLine2: String
    var timestamp: String
    var title: String
    
    init(itemId: Int, date: String, description: String, imageURL: String, locationLine1: String, locationLine2: String, timestamp: String, title: String) {
        
        self.itemId = itemId
        self.date = date
        self.description = description
        self.imageURL = imageURL
        self.locationLine1 = locationLine1
        self.locationLine2 = locationLine2
        self.timestamp = timestamp
        self.title = title
    }
}
